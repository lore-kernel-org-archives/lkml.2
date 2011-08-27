Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab1H0G3t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 02:29:49 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44820 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1H0G3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 02:29:47 -0400
Date: Fri, 26 Aug 2011 23:29:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Alfred E. Heggestad" <aeh@db.org>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: cm109 - fix checking return value of
 usb_control_msg
Message-ID: <20110827062941.GA29434@core.coreip.homeip.net>
References: <1314281210.5915.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314281210.5915.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 10:06:50PM +0800, Axel Lin wrote:
> If successful, usb_control_msg returns the number of bytes transferred,
> otherwise a negative error number.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks Axel.

-- 
Dmitry
