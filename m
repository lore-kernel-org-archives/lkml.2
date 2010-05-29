Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0E2In6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 04:43:58 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:43777 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab0E2Iny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 04:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QrcV+Wj1qn1AW5/t136zbTEkahURnuAaB+RYKViKlx2z0rGjHmdRXn5ByUbtGAUeFs
         BGyYfvaK6ne9B3mpzpkjxBUcWhK3zFxPYRKaziTfRAVykwseXF/ay/YuCM9+Qfv9VdoF
         m7O3mqixZuH3DWnEh4mKJeRr3gbjW/4Lt7CYs=
MIME-Version: 1.0
In-Reply-To: <AANLkTim04ZfMcPHRB2D_bqcAuguaGwySH2b6repuYLkk@mail.gmail.com>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100527223605.GB11364@srcf.ucam.org>
	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	<20100528043114.GC26177@thunk.org>
	<20100528103713.0a7952d9@lxorguk.ukuu.org.uk>
	<20100528114123.GA22947@srcf.ucam.org>
	<4BFFB681.1000105@nokia.com>
	<AANLkTim04ZfMcPHRB2D_bqcAuguaGwySH2b6repuYLkk@mail.gmail.com>
Date: Sat, 29 May 2010 10:43:53 +0200
Message-ID: <AANLkTimKI1G9qEKwpMOFvoWa5Qa__GcXGooE2_ZfmEHx@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Vitaly Wool <vitalywool@gmail.com>
To: Brian Swetland <swetland@google.com>
Cc: Igor Stoppa <igor.stoppa@nokia.com>, "tytso@mit.edu" <tytso@mit.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 2:52 PM, Brian Swetland <swetland@google.com> wrote:
> I am quite willing to state that on both MSM and OMAP based Android
> platforms, we've found that the suspend blocker model allows us to
> obtain a lower average power draw than if we don't use it -- Mike Chan
> provided some numbers earlier in another thread in the trivial device
> idle case, the win is of course much larger in the case of several
> poorly behaved apps being active.

Without the clear description of the experiments, that statement
proves just nothing other than your applications work better with your
model, but I would expect that to be so without any experiments at
all.

~Vitaly
