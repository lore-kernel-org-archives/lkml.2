Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0H0WC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 18:02:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50406 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab0H0WC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 18:02:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=CAkRPjHzbg2SweZOxT596DL4H0dIT2MtCe9HGV4UJSKeNb8ODHsyZS14t8n5/f6L9p
         L8WA34FPzg5rO7cNB4IxdpS6jWdSA2TAYVEoXyR1RYv15QgHhDWBYUjTNXDI6W0+PVsd
         A77wbNX4kL/oWCC2klDoGD3n9EZiTx/xocMLc=
MIME-Version: 1.0
In-Reply-To: <AANLkTikt_GNsswb+EaCTeX=-9oh_+g7XhLA94Gy24kSZ@mail.gmail.com>
References: <1281355646-12941-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTikt_GNsswb+EaCTeX=-9oh_+g7XhLA94Gy24kSZ@mail.gmail.com>
Date: Fri, 27 Aug 2010 15:02:54 -0700
X-Google-Sender-Auth: Rim6X6xOo4DAKhtAlftgwk310KQ
Message-ID: <AANLkTin2hdoDkGTHZxBEb1bLwTcQmzFeAi1dKKo53oJC@mail.gmail.com>
Subject: Re: [PATCH 00/14] DMAENGINE: ste_dma40: bugfixes and enhancements
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 10:19 AM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2010/8/9 Linus Walleij <linus.walleij@stericsson.com>:
>
>> This patch series adds a few bugfixes and some enhancements to the
>> DMA40 driver. Most should be pretty straight forward, others are
>> more elaborate, like the amendments to extend hw job lists at
>> runtime if there is already a queued job.
>
> Dan, can these be queued for -next? Shouldn't be any controversial
> stuff in them AFAICT.

Yes, consider them acked-by and on their way to -next.  I've been
preparing for the birth of my daughter who finally arrived on
Wednesday!  So expect intermittent attention to drivers/dma/ through
the middle of September.  I do plan to get this pushed before then,
and catch up on the i.mx sdma discussion.

Thanks for your review, and patience,

Regards,
Dan
