Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab1HWJ6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:58:24 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:36623 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752154Ab1HWJ6X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:58:23 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Michel =?utf-8?q?D=C3=A4nzer?= <michel@daenzer.net>
Subject: Re: [RFC PATCH v2] Resurrect Intel740 driver: i740fb
Date: Tue, 23 Aug 2011 11:58:18 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
References: <201108212242.12717.linux@rainbow-software.org> <201108231103.30591.linux@rainbow-software.org> <1314091533.21860.289.camel@thor.local>
In-Reply-To: <1314091533.21860.289.camel@thor.local>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201108231158.18173.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 August 2011, Michel Dänzer wrote:
> On Die, 2011-08-23 at 11:03 +0200, Ondrej Zary wrote:
> > On Monday 22 August 2011, Alan Cox wrote:
> > > > - 24bpp modes still don't work in fbtest but it looks like fbtest
> > > > bug!
> > > >
> > > > Is there any better way to test fb drivers than fbtest?
> > >
> > > X11 fbdev driver ?
> >
> > Thanks, completely forgot about that. It works fine even in 24bpp.
>
> Beware that Xorg defaults to 32 bpp for depth 24; did you verify in
> Xorg.0.log that it was really using 24 bpp?

Yes, found that very quickly as I was testing at 1280x1024 and the card cannot 
do 32bpp there. I had to set both DefaultDepth and DefaultFbBpp to 24 for X11 
to run.

-- 
Ondrej Zary
