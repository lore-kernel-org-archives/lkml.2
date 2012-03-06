Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030570Ab2CFPWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:22:13 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59852 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030355Ab2CFPWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:22:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of monstr@monstr.eu designates 10.216.133.72 as permitted sender) smtp.mail=monstr@monstr.eu
Message-ID: <4F562B9E.7060302@monstr.eu>
Date: Tue, 06 Mar 2012 16:22:06 +0100
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
References: <4F1EE861.4030405@monstr.eu> <4F200F64.9060203@monstr.eu> <CAK=WgbZDADRf1OF=uWbbsF+t2dx36tqj=kRftn5nd4RA7DtEnA@mail.gmail.com> <4F212E9E.9060807@monstr.eu> <CAK=WgbYMBDp3Qm8TErNrnDwn2ZTFt62+OuyyQvVE-jrnNsL6kg@mail.gmail.com> <4F391C1D.9020402@monstr.eu> <CAK=WgbYn6hrS4YLEdfp=0jSEfEwy-HkJmt5S06_j6gZFf0UTmQ@mail.gmail.com> <4F3BA962.9040109@monstr.eu> <4F3BC30A.4030301@monstr.eu> <4F3CC899.4070302@monstr.eu> <CAK=WgbaRF-L7M3VMZQdqFLUFOJuwFVkBH1hUNuJ51kSrzkaVjA@mail.gmail.com> <4F3CFFAD.9030402@monstr.eu> <4F3D032B.6090700@monstr.eu> <CAK=WgbZ3oXc+NQscdShqmu2wkzv=M-qBDCH2-k=5qSRX9W=z3Q@mail.gmail.com> <CAHTX3dJ4PruKO-wJLJU8W0boHFL0f6eoF+QNaoNjm5hu26YEow@mail.gmail.com> <CAK=WgbZBJJbFcoeZ+hY=BgyW_4yvOJPVNMZ18_9o+zY7tEc_pQ@mail.gmail.com> <4F425711.80102@monstr.eu> <CAK=WgbbNJMpndKqgW4SJjE=H-BqT7yVsB+F-kEfJWmW+ikJM+A@mail.gmail.com> <4F44DB23.4010303@monstr.eu> <CAK=Wgbaa9rv1pg19sWYFVX_Dvt0J0AzbRtKhPVnhP6WGdMeT9A@mail.gmail.com>
In-Reply-To: <CAK=Wgbaa9rv1pg19sWYFVX_Dvt0J0AzbRtKhPVnhP6WGdMeT9A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

Ohad Ben-Cohen wrote:
> On Wed, Feb 22, 2012 at 2:10 PM, Michal Simek <monstr@monstr.eu> wrote:
>> That will be great to get it. Please let me know when you have them.
> 
> Will do.

I have got the pandaboard (revision A3). u-boot and linux is running on it.
I just need to compile ducati-m3-core0.xem3

I have found the manual at https://github.com/GAnthony/syslink3

In sysbios-rpmsg readme I have found some TI tools which are required
and there is any compilation failure. I think it is because of missing CGT tools

        3) CGT TMS470: 4.9.0
           Public Links:-
             TMS470 Compiler is not available for free publicly. Please contact your TI representative.

Is it possible to compile firmware with this compiler?


I have also tried your bios version at
git://github.com/ohadbc/sysbios-rpmsg.git
branch: rpmsg_3.3_rc1_TLV

compilation passed but it doesn't generate bin file. :-(
I will investigate it tmr.

I would like to compile that bin file myself to be able to add some debug messages.

Thanks for your help,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
