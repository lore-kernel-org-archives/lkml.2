Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab0LHBP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:15:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62301 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699Ab0LHBD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=eZIm0eGIvzBsAsgTexoaZlO1vRLBn/n4Z4DshXUccQz+VEuUm9PBrOJl/frgTw+FSu
         rmKZkSmbamd80PqjOvHb62/SxO7Dqo+ljLqfhFDiogwP9ZXIS55va50/5xJrq6EulFaz
         3kqFgoJTPjcz/YMg4RcAMQcwkmW3baZ8aMfgo=
MIME-Version: 1.0
In-Reply-To: <1290510371-23077-3-git-send-email-jamie@jamieiles.com>
References: <1290510371-23077-1-git-send-email-jamie@jamieiles.com>
	<1290510371-23077-3-git-send-email-jamie@jamieiles.com>
Date: Tue, 7 Dec 2010 17:03:24 -0800
X-Google-Sender-Auth: lsrNNf9WTXwUwMR2-GSL9L1iM2s
Message-ID: <AANLkTi=Acre04XiLAAKN4fXuHsgY-gCDA=Yus92zmf_5@mail.gmail.com>
Subject: Re: [PATCH 2/4] dmaengine/dw_dmac: allow src/dst masters to be
 configured at runtime
From: Dan Williams <dan.j.williams@intel.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
        Jamie Iles <jamie.iles@picochip.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ adding Hans ]

On Tue, Nov 23, 2010 at 3:06 AM, Jamie Iles <jamie@jamieiles.com> wrote:
> Some platforms have flexible mastering capabilities and this needs
> to be selected at runtime. If the platform has specified private
> data in the form of the dw_dma_slave then fetch the source and
> destination masters from here. If this isn't present, default to
> the previous of 0 and 1.
>
> Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
> ---

Hi James,

Please integrate checkpatch into your workflow and fixup the trivial
whitespace damage (tabs-to-spaces) reports.

Also noticed this on patch 1/4 of this series.

Hans, can you provide an acked-by for this series when James reposts it?

Thanks,
Dan
