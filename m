Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab1AOAOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 19:14:53 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38294 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab1AOAOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 19:14:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=bAQshQcyYFLuQR9Q+EF7w5L8IZHQcrxmRQC0pY1vy8GiMb0zPenilgEA7jzMjqGyxT
         fSg+u6WkzdS8cG69S0ujrhAMQEHlWfcwCaW9ZuoGHluaPC13DSPklBGf5m45B3HDQXxB
         CQJu4lqmEfrbVAukQGgEj1taa7QK98Vtf5P00=
MIME-Version: 1.0
In-Reply-To: <4D2B07D0.5050602@atmel.com>
References: <1292435416-16927-1-git-send-email-nicolas.ferre@atmel.com>
	<4D2B07D0.5050602@atmel.com>
Date: Fri, 14 Jan 2011 16:14:50 -0800
X-Google-Sender-Auth: uXumQvW0ybHbFk2jIANGvdlIW9g
Message-ID: <AANLkTi=80SM+SVF=ZVW4M+QOOohzPrwjvmudMWdHVo3D@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: at_hdmac: use dma_address to program DMA hardware
From: Dan Williams <dan.j.williams@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 5:21 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Le 15/12/2010 18:50, Nicolas Ferre :
>> In atc_prep_slave_sg() function we use dma_address field of scatterlist with
>> sg_dma_address() macro instead of sg_phys(). DMA address is already computed
>> by dma_map_sg() or another mapping function in calling driver.
>
> Ping?
>

Applied.
