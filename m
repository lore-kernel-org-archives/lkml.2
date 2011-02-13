Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab1BMXcC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 18:32:02 -0500
Received: from sous-sol.org ([216.99.217.87]:38568 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754570Ab1BMXb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 18:31:56 -0500
Date: Sun, 13 Feb 2011 15:31:21 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Young <hidave.darkstar@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, Chris Wright <chrisw@sous-sol.org>
Subject: Re: Regression - Xorg start failed
Message-ID: <20110213233121.GA10495@sequoia.sous-sol.org>
References: <20110213062213.GA2525@darkstar.dhcp.inet.fi>
 <AANLkTimDuYgL2cSR8gE7Wrm9_w7cvG_wuUUsa=8TKs87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimDuYgL2cSR8gE7Wrm9_w7cvG_wuUUsa=8TKs87@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Airlie (airlied@gmail.com) wrote:
> On Sun, Feb 13, 2011 at 4:22 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > With kernel built from current linus's tree, I can not start xorg,
> > it failed with:
> 
> Me too!,
> 
> Thanks for bisceting this, I just tried -rc4 on my Fedora 13 laptop
> and wasn't looking forward to bisecting it.
> 
> If this isn't hitting later distros its probably an updated
> libpciaccess that fixed something.
> 
> libpciaccess-0.10.9-2.20091209.fc13.i686 is what is on this box.
> 
> Probably should revert first, then work out what is crapping out libpciaccess.

Are you running with SELinux enabled, if so can you paste the AVC error?
It's working for me here.

thanks,
-chris
