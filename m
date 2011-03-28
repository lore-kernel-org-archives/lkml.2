Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab1C1UAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 16:00:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49352 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab1C1UAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 16:00:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Commit 9661e92c10a9775243c1ecb73373528ed8725a10: sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:02.0/backlight/acpi_video0/device'
Date: Mon, 28 Mar 2011 22:00:39 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Alessandro Suardi <alessandro.suardi@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.1103242007300.2677@boston.corp.fedex.com> <BANLkTinTbez8+AMF9KaAx+Y5NFW_RMP5ig@mail.gmail.com> <AANLkTin1e0kn8uS6Hmz3y4kbCOGGKYpB+LU-vS2qsfKK@mail.gmail.com>
In-Reply-To: <AANLkTin1e0kn8uS6Hmz3y4kbCOGGKYpB+LU-vS2qsfKK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103282200.40099.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 28, 2011, Linus Torvalds wrote:
> On Mon, Mar 28, 2011 at 10:25 AM, Alessandro Suardi
> <alessandro.suardi@gmail.com> wrote:
> >>
> >> Sorry, yes - https://patchwork.kernel.org/patch/668351/
> >
> > Works on top of my -git18 + (unrelated) LVDS detection patch, thanks.
> >
> > Tested-by: Alessandro Suardi <alessandro.suardi@gmail.com>
> 
> Ok, which tree should this go through? I see from patchworks that it
> was sent to linux-acpi and lkml, but the commit it fixes actually came
> through Andrew.
> 
> Should I just take it directly?

Formally, it's an ACPI patch, but I guess Len wouldn't mind if you took it.
I've just acked it FWIW.

Rafael
