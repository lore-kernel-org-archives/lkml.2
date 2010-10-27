Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749Ab0J0P6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:58:41 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:16153 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757098Ab0J0P6k (ORCPT
	<rfc822;groupwise-jlee@novell.com:6:1>);
	Wed, 27 Oct 2010 11:58:40 -0400
Message-Id: <4CC8E6D70200002300022D7C@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Wed, 27 Oct 2010 09:58:31 -0600
From: "Joey Lee" <jlee@novell.com>
To: <corentin.chary@gmail.com>
Cc: <michel@daenzer.net>, <sedat.dilek@gmail.com>,
        <dri-devel@lists.freedesktop.org>,
        <acpi4asus-user@lists.sourceforge.net>, <mjg@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <platform-driver-x86@vger.kernel.org>
Subject: Re: drivers/platform/x86:
 Backlight-Add-backlight-type-v2.patch
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corentin, 

於 三，2010-10-27 於 13:39 +0200，Corentin Chary 提到：
> On Wed, Oct 27, 2010 at 1:06 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> > Hi,
> >
> > while testing linux-next I wanted to reactivate the backlight type
> > patches laying in my build-dir.
> >
> > Within 2.6.36-rcX cycle I had successfully tested the backlight type
> > patch [1] with an additional patch for radeon by Michel (posted to
> > dri-devel ML, see [2]).
> >
> > The main patch needs a little refreshing.
> >
> > v2: drivers/platform/x86/asus-laptop.c: Refreshed to fit linux-next
> > (next-20101027)
> >
> >
> > Kind Regards,
> > - Sedat -
> >
> > [1] https://patchwork.kernel.org/patch/163971/
> > [2] https://patchwork.kernel.org/patch/182352/
> >
> 
> Hi,
> 
> I think rfkill has the same problem, on some platforms, the platform
> driver will add a rfkill switch, but the network (wlan/wimax/whatever)
> driver may also add one. AFAIK, the platform one is more likely to be
> able to power down the device completly.
> 

Agreed your point!
x86/laptop or wmi driver borrow rfkill interface for power control but
confuse with userland applications.


Thank's
Joey Lee

