Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1BMHxu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 02:53:50 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44861 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab1BMHxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 02:53:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qTdxLOLs9ybY/8lOr56criGc6P1QJriVOSw3JOESCD3xPeOqkkhX3SOicVhPXSE9pL
         uvZ2vvduXPbEB6bkm/4CDEeKXzF2PeTamDcFrbH6WnajzF68othr7q8knnNo28i21BhV
         W0poSOHnyTVpAd4gLLqIkrocdSYt/vWHnLfB0=
MIME-Version: 1.0
In-Reply-To: <20110213062213.GA2525@darkstar.dhcp.inet.fi>
References: <20110213062213.GA2525@darkstar.dhcp.inet.fi>
Date: Sun, 13 Feb 2011 17:53:44 +1000
Message-ID: <AANLkTimDuYgL2cSR8gE7Wrm9_w7cvG_wuUUsa=8TKs87@mail.gmail.com>
Subject: Re: Regression - Xorg start failed
From: Dave Airlie <airlied@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, Chris Wright <chrisw@sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 4:22 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> Hi
>
> With kernel built from current linus's tree, I can not start xorg,
> it failed with:

Me too!,

Thanks for bisceting this, I just tried -rc4 on my Fedora 13 laptop
and wasn't looking forward to bisecting it.

If this isn't hitting later distros its probably an updated
libpciaccess that fixed something.

libpciaccess-0.10.9-2.20091209.fc13.i686 is what is on this box.

Probably should revert first, then work out what is crapping out libpciaccess.

Dave.
