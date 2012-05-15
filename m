Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab2EOGeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 02:34:20 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41131 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab2EOGeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 02:34:16 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbb0pRmnN-E_M7MLZoN5c_vYNj4AWsSvv-9ZDJzh3Pbjw@mail.gmail.com>
References: <1336654665-693-1-git-send-email-shubhrajyoti@ti.com>
	<CACRpkdbb0pRmnN-E_M7MLZoN5c_vYNj4AWsSvv-9ZDJzh3Pbjw@mail.gmail.com>
Date: Tue, 15 May 2012 12:04:15 +0530
Message-ID: <CAM=Q2csCk3B=mQH+zifE8y0XfPW=qgjH=Ya9PunaWRHFo+dLfQ@mail.gmail.com>
Subject: Re: [PATCH] spi/omap2-mcspi: convert to the pump message infrastructure
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Shubhrajyoti D <shubhrajyoti@ti.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, May 15, 2012 at 1:42 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, May 10, 2012 at 2:57 PM, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:
>
>> This patch converts the OMAP SPI driver to use the SPI infrastructure
>> pump message queue.Also fixes the below warning.
>> master is unqueued, this is deprecated
>>
>> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
>
> Final version of the patch?
Lest someone has comments.

> Acked-by: Linus Walleij <linus.walleij@linaro.org>
Thanks.

>
> Yours,
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
