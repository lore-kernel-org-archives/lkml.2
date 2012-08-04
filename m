Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab2HDOlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 10:41:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44050 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab2HDOlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 10:41:22 -0400
Message-ID: <1344091275.4520.1.camel@maxim-laptop>
Subject: Re: [bisected] nouveau: "Failed to idle channel x" after resume
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Aioanei Rares <krnl.list@gmail.com>
Cc: Martin Nyhus <martin.nyhus@gmx.com>, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
Date: Sat, 04 Aug 2012 17:41:15 +0300
In-Reply-To: <CAJCn4U=pLjiLVW_TT+JN5G177dh4RUwg=vinjBrS4udChOyqoQ@mail.gmail.com>
References: <20120611231842.221bd738@europa>
	 <20120705222429.43586868@europa>
	 <CAJCn4U=pLjiLVW_TT+JN5G177dh4RUwg=vinjBrS4udChOyqoQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-23 at 18:25 +0300, Aioanei Rares wrote: 
> On Thu, Jul 5, 2012 at 11:24 PM, Martin Nyhus <martin.nyhus@gmx.com> wrote:
> >
> > On Mon, 11 Jun 2012 23:18:42 +0200 Martin Nyhus wrote:
> > > after resuming from suspend nouveau starts writing Failed to idle
> > > channel x (where x is 2 or 3) to the log and X appears to stop and
> > > then restart only to stop again. Starting Firefox after resuming
> > > triggers the bugs every time, and bisecting leads to 03bd6efa
> > > ("drm/nv50/fifo: use hardware channel kickoff functionality").
> >
> > Hi Ben,
> > I'm still seeing this bug with the latest from Linus
> > (v3.5-rc5-98-g9e85a6f) and linux-next (next-20120705).
> >
> > lspci output:
> > 01:00.0 VGA compatible controller: nVidia Corporation G86 [GeForce
> > 8400M GS] (rev a1)
> >
> > Sorry I haven't followed up on this earlier,
> > Martin
> 
> I can confirm this with 3.5.0, Chromium and Arch Linux. It's a HP
> Pavilion laptop with a G86 [GeForce 8400 M GS] video card .
> Seems related to this bug:
> http://lists.freedesktop.org/archives/nouveau/2011-January/007358.html
> . If I can do anything else
> to help, I will be glad to.
Added nouveau@lists.freedesktop.org>

I confirm the same issue here.
will try to do dig it.

Best regards,
Maxim Levitsky

