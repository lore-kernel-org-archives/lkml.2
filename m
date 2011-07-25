Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab1GYI2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:28:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52499 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1GYI16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:27:58 -0400
Date: Mon, 25 Jul 2011 01:27:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: djkurtz@chromium.org
Cc: rydberg@euromail.se, chase.douglas@canonical.com, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 1/9 v2] Input: synaptics - refactor y inversion
Message-ID: <20110725082752.GB22937@core.coreip.homeip.net>
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org>
 <1311169146-20066-2-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311169146-20066-2-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 09:38:58PM +0800, djkurtz@chromium.org wrote:
> From: Daniel Kurtz <djkurtz@chromium.org>
> 
> Synaptics touchpads report increasing y from bottom to top.
> This is inverted from normal userspace "top of screen is 0" coordinates.
> Thus, the kernel driver reports inverted y coordinates to userspace.
> 
> This patch refactors this inversion.
> 

I really do not see the point...

Thanks.

-- 
Dmitry
