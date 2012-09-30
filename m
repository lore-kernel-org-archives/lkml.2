Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750856Ab2I3KFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 06:05:30 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:19899 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab2I3KF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:05:29 -0400
Date: Sun, 30 Sep 2012 12:05:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Huewe <peterhuewe@gmx.de>, linux-s390@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [-next]: s390 *_irq() link errors
Message-ID: <20120930120516.29be3022@endymion.delvare>
In-Reply-To: <CAMuHMdVV5F148RrqyGgD7q9y_C5tTnGi8S9hC4tus6wu-mLPxw@mail.gmail.com>
References: <CAMuHMdXqsPgfToNyjbxJ-WM=-kEEvAweE03wb3vtkwVO+-RR3A@mail.gmail.com>
	<20120927115134.GA5654@osiris.de.ibm.com>
	<CAMuHMdUqXnY5ZNgjYN0YMpLkPw0j41MXM18H9qiLoEk-BzKYMg@mail.gmail.com>
	<20120930105350.16e54037@endymion.delvare>
	<CAMuHMdV=mcVuVuJaWrVjwxLz0+gkBoC=NUq6=C176B3W7j8Yag@mail.gmail.com>
	<20120930112052.733ce361@endymion.delvare>
	<CAMuHMdVV5F148RrqyGgD7q9y_C5tTnGi8S9hC4tus6wu-mLPxw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Sep 2012 11:35:41 +0200, Geert Uytterhoeven wrote:
> On Sun, Sep 30, 2012 at 11:20 AM, Jean Delvare <khali@linux-fr.org> wrote:
> > On Sun, 30 Sep 2012 11:08:41 +0200, Geert Uytterhoeven wrote:
> >> On Sun, Sep 30, 2012 at 10:53 AM, Jean Delvare <khali@linux-fr.org> wrote:
> >> > I thought we were trying to move away from explicit arch exclusions,
> >> > but if S390 is special then fine with me. I've folded Heiko's fix into
> >>
> >> "depends on GENERIC_HARDIRQS" is the alternative...
> >
> > That would make even less sense to me, I2C can work just fine without
> > IRQs.
> 
> For the individual drivers that need it...

Oh, of course. Sorry I was probably not completely awaken ;)

Either way is fine with me if it makes developers and users happy.

-- 
Jean Delvare
