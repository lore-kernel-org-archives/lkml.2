Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab1HHT3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 15:29:04 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39283 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab1HHT3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 15:29:02 -0400
MIME-Version: 1.0
In-Reply-To: <1312830866-2932-1-git-send-email-robherring2@gmail.com>
References: <1312830866-2932-1-git-send-email-robherring2@gmail.com>
Date: Tue, 9 Aug 2011 00:59:01 +0530
Message-ID: <CABb+yY2bt0M0X0o-2578eBcP7vwvjykCykKv6e0+HZ17Qset_w@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: pl330: add missing include of scatterlist.h
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vkoul@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 12:44 AM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> scatterlist.h was getting implicitly included and now is not which
> causes this compile error:
>
> drivers/dma/pl330.c: In function ‘pl330_prep_slave_sg’:
> drivers/dma/pl330.c:603:2: error: implicit declaration of function
> ‘for_each_sg’
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Jassi Brar <jassisinghbrar@gmail.com>
> Cc: Vinod Koul <vkoul@infradead.org>

Acked-by: Jassi Brar <jassisinghbrar@gmail.com>

thnx
