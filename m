Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab1LHBEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 20:04:23 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51141 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab1LHBEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 20:04:21 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZC8LOOLkWbrPbXN_nKaw-WvueusYDyrX48Q1Pcdwv3Aw@mail.gmail.com>
References: <1317189007-23033-1-git-send-email-alim.akhtar@samsung.com> <CACRpkdZC8LOOLkWbrPbXN_nKaw-WvueusYDyrX48Q1Pcdwv3Aw@mail.gmail.com>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Thu, 8 Dec 2011 10:03:38 +0900
Message-ID: <CAGOxZ52w1nn8g4d_vuNAzjA9qYZ1=yEfihFvSOK+pBz=ZD=J7Q@mail.gmail.com>
Subject: Re: [PATCH V2 0/1] dmaengine/amba-pl08x: Add support for s3c64xx DMAC
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,
sorry for the delay in submitting V3 of the pl080 patches for s3c64xx.
I am very busy with my current assignment.
I will come back to my patch series incorporating yours and Viresh
suggestions in v3.

Thanks!!

Regards,
Alim

On Thu, Dec 8, 2011 at 8:43 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Sep 28, 2011 at 7:50 AM, Alim Akhtar <alim.akhtar@samsung.com> wrote:
>
>> This patch modifies the amba-pl08x driver for s3c64xx.
>> The DMA controller of S3C64XX is a variant of PrimeCell pl080 DMAC.
>> S3C64xx contents extra register to hold the TransferSize.
>
> Alim what is happening with this patch series?
>
> I was really happy with the rate of progress we had and Viresh & I
> have given most feedback needed to complete this I think.
>
> Yours,
> Linus Walleij
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



-- 
aLim akHtaR
mAin hUn nA :-)
