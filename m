Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2BTUMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 15:12:15 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36185 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab2BTUMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 15:12:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ohad@wizery.com designates 10.50.11.129 as permitted sender) smtp.mail=ohad@wizery.com
MIME-Version: 1.0
X-Originating-IP: [93.172.89.250]
In-Reply-To: <4F425711.80102@monstr.eu>
References: <4F1EE861.4030405@monstr.eu> <CAK=Wgba5kT8AwLtuHyosucYnWf-EA+xpE1kzmssfhSC7ZXQA=g@mail.gmail.com>
 <4F1FF870.3000105@monstr.eu> <CAK=WgbZwaxMPsMiNcq5yFvBLrcODqGgDT6b=mmQ91JBVtTEyXA@mail.gmail.com>
 <4F200F64.9060203@monstr.eu> <CAK=WgbZDADRf1OF=uWbbsF+t2dx36tqj=kRftn5nd4RA7DtEnA@mail.gmail.com>
 <4F212E9E.9060807@monstr.eu> <CAK=WgbYMBDp3Qm8TErNrnDwn2ZTFt62+OuyyQvVE-jrnNsL6kg@mail.gmail.com>
 <4F391C1D.9020402@monstr.eu> <CAK=WgbYn6hrS4YLEdfp=0jSEfEwy-HkJmt5S06_j6gZFf0UTmQ@mail.gmail.com>
 <4F3BA962.9040109@monstr.eu> <4F3BC30A.4030301@monstr.eu> <4F3CC899.4070302@monstr.eu>
 <CAK=WgbaRF-L7M3VMZQdqFLUFOJuwFVkBH1hUNuJ51kSrzkaVjA@mail.gmail.com>
 <4F3CFFAD.9030402@monstr.eu> <4F3D032B.6090700@monstr.eu> <CAK=WgbZ3oXc+NQscdShqmu2wkzv=M-qBDCH2-k=5qSRX9W=z3Q@mail.gmail.com>
 <CAHTX3dJ4PruKO-wJLJU8W0boHFL0f6eoF+QNaoNjm5hu26YEow@mail.gmail.com>
 <CAK=WgbZBJJbFcoeZ+hY=BgyW_4yvOJPVNMZ18_9o+zY7tEc_pQ@mail.gmail.com> <4F425711.80102@monstr.eu>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 20 Feb 2012 22:11:53 +0200
Message-ID: <CAK=WgbbNJMpndKqgW4SJjE=H-BqT7yVsB+F-kEfJWmW+ikJM+A@mail.gmail.com>
Subject: Re: remoteproc: Load coprocessor code to the specific main memory location
To: monstr@monstr.eu
Cc: LKML <linux-kernel@vger.kernel.org>,
        John Williams <john.williams@petalogix.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "Grosen, Mark" <mgrosen@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Mon, Feb 20, 2012 at 4:22 PM, Michal Simek <monstr@monstr.eu> wrote:
> IRC you mentioned somewhere that you maybe will have firmware which is
> possible to
> compiled by gcc and which doesn't required that TI tools. Am I correct or
> that was
> something totally different?

You're correct - this is in the works, but I'm afraid I don't have any
scheduling information about this, sorry.

But we have folks from another vendor now who got rpmsg working, and
are working out the legal issues so they can release the RTOS sources.
Hopefully that'll be released soon.

Thanks,
Ohad.
