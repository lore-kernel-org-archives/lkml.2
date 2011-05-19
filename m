Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab1ESKOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 06:14:45 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:42825 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824Ab1ESKOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 06:14:44 -0400
Date: Thu, 19 May 2011 15:44:27 +0530
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "richard.purdie@linuxfoundation.org" 
	<richard.purdie@linuxfoundation.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>
Subject: Re: [PATCH] leds: add regulator to lm3530 driver
Message-ID: <20110519101426.GA5268@bnru05.bnr.st.com>
References: <1305550078-28389-1-git-send-email-shreshthakumar.sahu@stericsson.com>
 <20110518161814.8e79efab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110518161814.8e79efab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 01:18:14 +0200, Andrew Morton wrote:
> On Mon, 16 May 2011 18:17:58 +0530
> Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com> wrote:
> 
> > From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> > 
> > Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> 
> No changelog.  We can't think of anything which we can add to help
> people understand what the patch does and why it does it?
I will repost the patch with brief about the patch.

> 
> Has this been runtime tested with CONFIG_REGULATOR=n?
This has been testd with CONFIG_REGULATOR=n as well as CONFIG_REGULATOR=y in 
local branch for U5500 platform. With Linux-Next I have only done build.
