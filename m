Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab2LBLnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 06:43:17 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36460 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab2LBLnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 06:43:15 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CAKMK7uF9+mQMy-NRHz-nO=NQTDxi-=t+0dEsFpEPJDkx6XwRVQ@mail.gmail.com>
References: <1328143975.121508.1354405791738.JavaMail.root@elliptictech.com>
	<1394390827.121688.1354447977594.JavaMail.root@elliptictech.com>
	<CAKMK7uF9+mQMy-NRHz-nO=NQTDxi-=t+0dEsFpEPJDkx6XwRVQ@mail.gmail.com>
Date: Sun, 2 Dec 2012 12:43:14 +0100
Message-ID: <CAKMK7uGrLvmDa+pqStAK_E_rEmgAgR+BO6+-m2dgUk6Ut6DuCQ@mail.gmail.com>
Subject: Re: Brightness control fails between 3.6.8 and 3.7.0-rc7 (Intel
 915/Dell Vostro 3560)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Tom St Denis <tstdenis@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including a bunch more lists to the cc.

On Sun, Dec 2, 2012 at 12:42 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Sun, Dec 2, 2012 at 12:32 PM, Tom St Denis <tstdenis@elliptictech.com> wrote:
>> I've narrowed it down to sometime between v3.6.8 and v3.7-rc1.  So none of the v3.7 series will work with this GPU/panel.
>
> Hm, that's still a few hundred relevant commits intermingled with a
> few thousand that likely don't matter ;-) Can you please attempt a
> kernel bisect with git? For a nice howto check out
> http://www.reactivated.net/weblog/archives/2006/01/using-git-bisect-to-find-buggy-kernel-patches/
>
> Also, can you please check which of the different backlight controls
> in /sys/class/backlight work on 3.6 (and whether any of them still
> work on 3.7)?
>
> Thanks, Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
