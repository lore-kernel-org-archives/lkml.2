Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0KIWjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:39:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39683 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab0KIWju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:39:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Lq3xrZvkbGg7lphZItViuctbmRMADbAwIcNZGFksYyrTikIu4XTKOd4Rz998FOnevQ
         Lt1UrIv+nyHteS0/L6uvegKbDY8rWwuKAPR3DUIK8Rv6WeSonrzX9kVHzKwIVxmIclzF
         /VAxiRMDUgCMY+OIQ8963QEbhgTUi9/HnNH/I=
MIME-Version: 1.0
In-Reply-To: <20101109221035.GB19847@kroah.com>
References: <AANLkTinZF-47WQyF5k1Nv64NjfMNSQ-+oE0eGycR24NM@mail.gmail.com>
	<AANLkTikB0zhN13u5OtRwviOv-rFDW-vFTmq0t7ALuO7N@mail.gmail.com>
	<201011091729.17679.arnd@arndb.de>
	<20101109165509.GA9698@kroah.com>
	<AANLkTinFW431t9XFqHc=wZAws9gjT0ikrc03J83kH7iF@mail.gmail.com>
	<20101109172511.GA10958@kroah.com>
	<AANLkTi=CKERMcSLXwQa7G55P69DO--UPN9HgOScHP_yO@mail.gmail.com>
	<20101109175828.GA27627@kroah.com>
	<AANLkTin0Lszi6MVo8GBWmpvMQRL3V+VGbtGdaMkBe5XO@mail.gmail.com>
	<20101109221035.GB19847@kroah.com>
Date: Wed, 10 Nov 2010 00:39:47 +0200
Message-ID: <AANLkTimB5=OZWSaOGXKL49oWT+PnjADq5hT3w_ii0ZMb@mail.gmail.com>
Subject: Re: [GIT PULL] fixes for tidspbridge 2.6.37-rc1
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 12:10 AM, Greg KH <greg@kroah.com> wrote:
> On Tue, Nov 09, 2010 at 11:53:29PM +0200, Felipe Contreras wrote:
>> You mean after this pull, or should Omar re-send this pull request?
>
> I'm not pulling _anything_ at the moment for this driver.
>
> I want to see patches, not a pull request please, as these need to be
> reviewed very closely.

It's a revert from a non-working state to a working state, there's not
much to review there. So if Omar sends the patches with my and his
s-o-b, would you apply the patches?

Getting these patches in one way or the other seems to be the only way
we can get this driver to work on 2.6.37.

-- 
Felipe Contreras
