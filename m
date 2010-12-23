Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab0LWJca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 04:32:30 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60733 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab0LWJc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 04:32:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rNqJNRVF9vfMDSchEzCmVklXv+d5Fv0anm72RQn/BPmuFy9ahv1krjfEvZV+/wlPtr
         /zLY7BDmHHeKLzN/+9It1VygVTh78XLN9+OlJ1hBXwgbNc6mZgPVaSNKtqU6tvufuv+b
         lAkdSj1duKMM7RQp81IfgNUwQ7yBceaDdCXCc=
MIME-Version: 1.0
In-Reply-To: <AANLkTik4N5Caw2f4nNFgYXDjxwCMvkyLGyTrkz+vDfXS@mail.gmail.com>
References: <alpine.DEB.2.00.1012212339090.30885@skynet.skynet.ie>
	<s5hei99vkqj.wl%tiwai@suse.de>
	<c6d829$pujifv@fmsmga001.fm.intel.com>
	<AANLkTik4N5Caw2f4nNFgYXDjxwCMvkyLGyTrkz+vDfXS@mail.gmail.com>
Date: Thu, 23 Dec 2010 10:32:27 +0100
Message-ID: <AANLkTin_BLuv+T5jg6nM2KxaQjpR+T0JZACR480t5N0=@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Alex Riesen <raa.lkml@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Takashi Iwai <tiwai@suse.de>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 04:54, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Why does that code need to figure out some LVDS clock from the BIOS?
> Why can't the code look at the actual hardware state or similar, since
> presumably the screen is on after boot. THAT we can rely on, since a
> BIOS that doesn't initialize LVDS is not going to ever ship even as
> pre-release.

What if the system booted with it's display turned off? Like a closed
laptop lid or disconnected monitor?
