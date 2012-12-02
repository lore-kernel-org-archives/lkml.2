Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab2LBNtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 08:49:36 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:64909 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2LBNte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 08:49:34 -0500
Date: Sun, 2 Dec 2012 08:49:33 -0500 (EST)
From: Tom St Denis <tstdenis@elliptictech.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Message-ID: <1738269086.121732.1354456173261.JavaMail.root@elliptictech.com>
In-Reply-To: <CAKMK7uGrLvmDa+pqStAK_E_rEmgAgR+BO6+-m2dgUk6Ut6DuCQ@mail.gmail.com>
Subject: Re: Brightness control fails between 3.6.8 and 3.7.0-rc7 (Intel
 915/Dell Vostro 3560)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.17.19.112]
X-Mailer: Zimbra 7.2.1_GA_2790 (ZimbraWebClient - GC23 (Linux)/7.2.1_GA_2790)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok so on v3.7-rc1 [and I suspect up] I can manually control the brightness by echoing to 

/sys/class/backlight/intel_backlight/brightness

But I still can't use the buttons to control it (it only goes one tick down from max and stops there).  I'm using GNOME3 from a x86_64 unstable debian install [up to date with latest].

I just noticed that under v3.7 I have a new directory /sys/class/backlight/acpi_video1 which is what GNOME is actually controlling.  I can't disable ACPI video control so is there a workaround?

Tom



----- Original Message -----
> From: "Daniel Vetter" <daniel.vetter@ffwll.ch>
> To: "Tom St Denis" <tstdenis@elliptictech.com>
> Cc: linux-kernel@vger.kernel.org, "intel-gfx" <intel-gfx@lists.freedesktop.org>, "dri-devel"
> <dri-devel@lists.freedesktop.org>
> Sent: Sunday, 2 December, 2012 6:43:14 AM
> Subject: Re: Brightness control fails between 3.6.8 and 3.7.0-rc7 (Intel 915/Dell Vostro 3560)
> 
> Including a bunch more lists to the cc.
> 
> On Sun, Dec 2, 2012 at 12:42 PM, Daniel Vetter
> <daniel.vetter@ffwll.ch> wrote:
> > On Sun, Dec 2, 2012 at 12:32 PM, Tom St Denis
> > <tstdenis@elliptictech.com> wrote:
> >> I've narrowed it down to sometime between v3.6.8 and v3.7-rc1.  So
> >> none of the v3.7 series will work with this GPU/panel.
> >
> > Hm, that's still a few hundred relevant commits intermingled with a
> > few thousand that likely don't matter ;-) Can you please attempt a
> > kernel bisect with git? For a nice howto check out
> > http://www.reactivated.net/weblog/archives/2006/01/using-git-bisect-to-find-buggy-kernel-patches/
> >
> > Also, can you please check which of the different backlight
> > controls
> > in /sys/class/backlight work on 3.6 (and whether any of them still
> > work on 3.7)?
> >
> > Thanks, Daniel
> > --
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> 
> 
> 
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> 
