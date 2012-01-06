Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459Ab2AFBwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 20:52:12 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43644 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab2AFBwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 20:52:11 -0500
Date: Fri, 6 Jan 2012 05:52:06 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH] power: Assume mains power by default
Message-ID: <20120106015206.GA15103@oksana.dev.rtsoft.ru>
References: <201112102253.36940.jdelvare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201112102253.36940.jdelvare@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 10, 2011 at 10:53:36PM +0100, Jean Delvare wrote:
> If no power class device is found in power_supply_is_system_supplied(),
> the function currently returns 0, which basically means that the system
> is supposed to be running on battery. In practice, mobile devices tend
> to always implement at least one power class device and more often two
> (battery and AC adapter). Systems with no registered power class
> devices are more likely to be desktop systems, where the system is
> always powered by mains.
> 
> So, change the default return value of
> power_supply_is_system_supplied() from 0 (running on battery) to 1
> (running on mains.)
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> ---

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
