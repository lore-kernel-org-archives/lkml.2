Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab2BPR14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 12:27:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38511 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2BPR1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 12:27:55 -0500
MIME-Version: 1.0
X-Originating-IP: [108.60.121.129]
In-Reply-To: <4F3CFFAD.9030402@monstr.eu>
References: <4F1EE861.4030405@monstr.eu> <CAK=Wgba5kT8AwLtuHyosucYnWf-EA+xpE1kzmssfhSC7ZXQA=g@mail.gmail.com>
 <4F1FF870.3000105@monstr.eu> <CAK=WgbZwaxMPsMiNcq5yFvBLrcODqGgDT6b=mmQ91JBVtTEyXA@mail.gmail.com>
 <4F200F64.9060203@monstr.eu> <CAK=WgbZDADRf1OF=uWbbsF+t2dx36tqj=kRftn5nd4RA7DtEnA@mail.gmail.com>
 <4F212E9E.9060807@monstr.eu> <CAK=WgbYMBDp3Qm8TErNrnDwn2ZTFt62+OuyyQvVE-jrnNsL6kg@mail.gmail.com>
 <4F391C1D.9020402@monstr.eu> <CAK=WgbYn6hrS4YLEdfp=0jSEfEwy-HkJmt5S06_j6gZFf0UTmQ@mail.gmail.com>
 <4F3BA962.9040109@monstr.eu> <4F3BC30A.4030301@monstr.eu> <4F3CC899.4070302@monstr.eu>
 <CAK=WgbaRF-L7M3VMZQdqFLUFOJuwFVkBH1hUNuJ51kSrzkaVjA@mail.gmail.com> <4F3CFFAD.9030402@monstr.eu>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 16 Feb 2012 18:27:34 +0100
Message-ID: <CAK=WgbbNaDGObazuLZODad6-O_8oJ5j=isS50gQ0DFefo+UW1w@mail.gmail.com>
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

On Thu, Feb 16, 2012 at 2:07 PM, Michal Simek <monstr@monstr.eu> wrote:
> Above is condition "if (virtio_has_feature(vdev, VIRTIO_RPMSG_F_NS))" which
> is failing for me.

You might want to debug why.

For the dynamic channel creation to work, your rpmsg vdev should have
VIRTIO_RPMSG_F_NS. But that's part of the generic code, and you should
not bother about it - it should just work.

> How does look like that structure for vring channels? It is probably mapped
> any structure. Can you point me which one?

I'm sorry, can you please rephrase the question ? I'm not sure I'm following.

Thanks,
Ohad.
