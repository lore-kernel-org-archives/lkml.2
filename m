Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136Ab1GZEj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 00:39:56 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:46983 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1GZEjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 00:39:52 -0400
MIME-Version: 1.0
In-Reply-To: <1311627904-24045-1-git-send-email-robherring2@gmail.com>
References: <1310518811-379-1-git-send-email-robherring2@gmail.com>
	<1311627904-24045-1-git-send-email-robherring2@gmail.com>
Date: Tue, 26 Jul 2011 10:09:51 +0530
Message-ID: <CABb+yY1BydX=YMe_nenkYr+bsH-3k3gObO3qav5AA5DrxMP=2Q@mail.gmail.com>
Subject: Re: [PATCH v2] dmaengine: pl330: make platform data optional
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Vinod Koul <vkoul@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 2:35 AM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> The pl330 needs platform data for describing peripheral connections, but
> some platforms may only support memory to memory dma channels. In this
> case, we can probe for how many channels there are and don't need the
> platform data.
>
> As memcpy requests don't need channel private data to hold peripheral
> info, allow private data to be NULL in this case.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Jassi Brar <jassisinghbrar@gmail.com>
> Cc: Vinod Koul <vkoul@infradead.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
>
> ---
> Vinod, Can you apply this updated version instead?
>
> v2:
>  - Added null ptr check
>
>  drivers/dma/pl330.c |   64 ++++++++++++++++++++++++++++----------------------
>  1 files changed, 36 insertions(+), 28 deletions(-)

Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
