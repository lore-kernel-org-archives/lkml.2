Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab0CYFeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:34:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63257 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab0CYFem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:34:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mnxp1NxPPGuEHJeWI4AAd7f8i3YOWMgdrnf1EPql5JR1rLdI41hHiNCjzSiUDp2zSD
         KAXxNZ9NluYSUkO9hm36Cfl/+g8/Vh2yLHA7yXsNyfaQFqT8pVEf60vrmTS+rikgZfl9
         ZQS6afTrNNJzX31nYfPqwSm5nV6KU0GlMYbtc=
MIME-Version: 1.0
In-Reply-To: <4BAAD5BB.7050101@samsung.com>
References: <4BAAD5BB.7050101@samsung.com>
Date: Thu, 25 Mar 2010 14:34:41 +0900
Message-ID: <1b68c6791003242234h106d9530p12b5a046a906227e@mail.gmail.com>
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
From: jassi brar <jassisinghbrar@gmail.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: dan.j.williams@intel.com, linus.ml.walleij@gmail.com,
       kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 12:17 PM, Joonyoung Shim
<jy0922.shim@samsung.com> wrote:
> The PL330 is currently the dma controller using at the S5PC1XX arm SoC.
> This supports DMA_MEMCPY and DMA_SLAVE.
>
> The datasheet for the PL330 can find below url:
> http://infocenter.arm.com/help/topic/com.arm.doc.ddi0424a/DDI0424A_dmac_pl330_r0p0_trm.pdf
>
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> ---
> Change log:
>
> v2: Convert into an amba_device driver.
>    Code clean and update from v1 patch review.

[CC'ing Russell and Ben as stakeholders]

Dear Maintainers

I too have been writing a driver for PL330 after taking into account the
suggestions of Russell, Ben and other participants of the thread
http://lists.infradead.org/pipermail/linux-arm-kernel/2010-February/009856.html

If you don't think this driver conflicts with the theme of the thread,
may I ask you
to please put this driver on hold until you checkout my implementation
of solution
to the issue... which should be soon.

Regards,
Jaswinder Singh
Solution-1 Group
Linux Kernel Team
System LSI Division
Samsung Electronics Co., Ltd.
