Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab2BVMKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 07:10:17 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44966 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab2BVMKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:10:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of monstr@monstr.eu designates 10.14.28.194 as permitted sender) smtp.mail=monstr@monstr.eu
Message-ID: <4F44DB23.4010303@monstr.eu>
Date: Wed, 22 Feb 2012 13:10:11 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        John Williams <john.williams@petalogix.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "Grosen, Mark" <mgrosen@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: remoteproc: Load coprocessor code to the specific main memory
 location
References: <4F1EE861.4030405@monstr.eu> <4F1FF870.3000105@monstr.eu> <CAK=WgbZwaxMPsMiNcq5yFvBLrcODqGgDT6b=mmQ91JBVtTEyXA@mail.gmail.com> <4F200F64.9060203@monstr.eu> <CAK=WgbZDADRf1OF=uWbbsF+t2dx36tqj=kRftn5nd4RA7DtEnA@mail.gmail.com> <4F212E9E.9060807@monstr.eu> <CAK=WgbYMBDp3Qm8TErNrnDwn2ZTFt62+OuyyQvVE-jrnNsL6kg@mail.gmail.com> <4F391C1D.9020402@monstr.eu> <CAK=WgbYn6hrS4YLEdfp=0jSEfEwy-HkJmt5S06_j6gZFf0UTmQ@mail.gmail.com> <4F3BA962.9040109@monstr.eu> <4F3BC30A.4030301@monstr.eu> <4F3CC899.4070302@monstr.eu> <CAK=WgbaRF-L7M3VMZQdqFLUFOJuwFVkBH1hUNuJ51kSrzkaVjA@mail.gmail.com> <4F3CFFAD.9030402@monstr.eu> <4F3D032B.6090700@monstr.eu> <CAK=WgbZ3oXc+NQscdShqmu2wkzv=M-qBDCH2-k=5qSRX9W=z3Q@mail.gmail.com> <CAHTX3dJ4PruKO-wJLJU8W0boHFL0f6eoF+QNaoNjm5hu26YEow@mail.gmail.com> <CAK=WgbZBJJbFcoeZ+hY=BgyW_4yvOJPVNMZ18_9o+zY7tEc_pQ@mail.gmail.com> <4F425711.80102@monstr.eu> <CAK=WgbbNJMpndKqgW4SJjE=H-BqT7yVsB+F-kEfJWmW+ikJM+A@mail.gmail.com>
In-Reply-To: <CAK=WgbbNJMpndKqgW4SJjE=H-BqT7yVsB+F-kEfJWmW+ikJM+A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ohad Ben-Cohen wrote:
> Hi Michal,
> 
> On Mon, Feb 20, 2012 at 4:22 PM, Michal Simek <monstr@monstr.eu> wrote:
>> IRC you mentioned somewhere that you maybe will have firmware which is
>> possible to
>> compiled by gcc and which doesn't required that TI tools. Am I correct or
>> that was
>> something totally different?
> 
> You're correct - this is in the works, but I'm afraid I don't have any
> scheduling information about this, sorry.
> 
> But we have folks from another vendor now who got rpmsg working, and
> are working out the legal issues so they can release the RTOS sources.
> Hopefully that'll be released soon.

That will be great to get it. Please let me know when you have them.
After EW I will look at it anyway.


Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
