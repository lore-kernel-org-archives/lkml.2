Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab0KIWwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:52:54 -0500
Received: from kroah.org ([198.145.64.141]:36003 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab0KIWww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:52:52 -0500
Date: Tue, 9 Nov 2010 14:52:29 -0800
From: Greg KH <greg@kroah.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [GIT PULL] fixes for tidspbridge 2.6.37-rc1
Message-ID: <20101109225229.GA992@kroah.com>
References: <AANLkTikB0zhN13u5OtRwviOv-rFDW-vFTmq0t7ALuO7N@mail.gmail.com>
 <201011091729.17679.arnd@arndb.de>
 <20101109165509.GA9698@kroah.com>
 <AANLkTinFW431t9XFqHc=wZAws9gjT0ikrc03J83kH7iF@mail.gmail.com>
 <20101109172511.GA10958@kroah.com>
 <AANLkTi=CKERMcSLXwQa7G55P69DO--UPN9HgOScHP_yO@mail.gmail.com>
 <20101109175828.GA27627@kroah.com>
 <AANLkTin0Lszi6MVo8GBWmpvMQRL3V+VGbtGdaMkBe5XO@mail.gmail.com>
 <20101109221035.GB19847@kroah.com>
 <AANLkTimB5=OZWSaOGXKL49oWT+PnjADq5hT3w_ii0ZMb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimB5=OZWSaOGXKL49oWT+PnjADq5hT3w_ii0ZMb@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 12:39:47AM +0200, Felipe Contreras wrote:
> On Wed, Nov 10, 2010 at 12:10 AM, Greg KH <greg@kroah.com> wrote:
> > On Tue, Nov 09, 2010 at 11:53:29PM +0200, Felipe Contreras wrote:
> >> You mean after this pull, or should Omar re-send this pull request?
> >
> > I'm not pulling _anything_ at the moment for this driver.
> >
> > I want to see patches, not a pull request please, as these need to be
> > reviewed very closely.
> 
> It's a revert from a non-working state to a working state, there's not
> much to review there. So if Omar sends the patches with my and his
> s-o-b, would you apply the patches?

Was my previous email about not taking anything unless it went through
Omar not specific enough?

