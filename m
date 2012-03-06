Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab2CFQ0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:26:38 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44651 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740Ab2CFQ0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:26:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ohad@wizery.com designates 10.50.89.137 as permitted sender) smtp.mail=ohad@wizery.com
MIME-Version: 1.0
X-Originating-IP: [93.172.188.121]
In-Reply-To: <4F562B9E.7060302@monstr.eu>
References: <4F1EE861.4030405@monstr.eu> <4F200F64.9060203@monstr.eu>
 <CAK=WgbZDADRf1OF=uWbbsF+t2dx36tqj=kRftn5nd4RA7DtEnA@mail.gmail.com>
 <4F212E9E.9060807@monstr.eu> <CAK=WgbYMBDp3Qm8TErNrnDwn2ZTFt62+OuyyQvVE-jrnNsL6kg@mail.gmail.com>
 <4F391C1D.9020402@monstr.eu> <CAK=WgbYn6hrS4YLEdfp=0jSEfEwy-HkJmt5S06_j6gZFf0UTmQ@mail.gmail.com>
 <4F3BA962.9040109@monstr.eu> <4F3BC30A.4030301@monstr.eu> <4F3CC899.4070302@monstr.eu>
 <CAK=WgbaRF-L7M3VMZQdqFLUFOJuwFVkBH1hUNuJ51kSrzkaVjA@mail.gmail.com>
 <4F3CFFAD.9030402@monstr.eu> <4F3D032B.6090700@monstr.eu> <CAK=WgbZ3oXc+NQscdShqmu2wkzv=M-qBDCH2-k=5qSRX9W=z3Q@mail.gmail.com>
 <CAHTX3dJ4PruKO-wJLJU8W0boHFL0f6eoF+QNaoNjm5hu26YEow@mail.gmail.com>
 <CAK=WgbZBJJbFcoeZ+hY=BgyW_4yvOJPVNMZ18_9o+zY7tEc_pQ@mail.gmail.com>
 <4F425711.80102@monstr.eu> <CAK=WgbbNJMpndKqgW4SJjE=H-BqT7yVsB+F-kEfJWmW+ikJM+A@mail.gmail.com>
 <4F44DB23.4010303@monstr.eu> <CAK=Wgbaa9rv1pg19sWYFVX_Dvt0J0AzbRtKhPVnhP6WGdMeT9A@mail.gmail.com>
 <4F562B9E.7060302@monstr.eu>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 6 Mar 2012 18:26:16 +0200
Message-ID: <CAK=WgbbZwuqmjvY13M83CPsUFv0+DXxCHvnL5S3WpmDW_Qco3A@mail.gmail.com>
Subject: Re: remoteproc: Load coprocessor code to the specific main memory location
To: Michal Simek <monstr@monstr.eu>, "Grosen, Mark" <mgrosen@ti.com>,
        "Anna, Suman" <s-anna@ti.com>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        John Williams <john.williams@petalogix.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Tue, Mar 6, 2012 at 5:22 PM, Michal Simek <monstr@monstr.eu> wrote:
>       3) CGT TMS470: 4.9.0
>          Public Links:-
>            TMS470 Compiler is not available for free publicly. Please
> contact your TI representative.

I think you need those tools and can't build the image without them
(Mark/Suman/Fernando, PCMIIW).

Btw I was also told that it will soon be possible to build the
firmware with gcc. Mark will know more details about this.

Thanks,
Ohad.
