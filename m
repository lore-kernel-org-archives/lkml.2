Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab0FYGNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 02:13:05 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:39916 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab0FYGNC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 02:13:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=IEgsfKKlF4kLcubLLgPVlHU6pJMCW/dnlyXz7fDXztLhvFTGl//DwJUKFMyIu0QR7B
         z95pQIUyWML/fiQzaBt/Ul5XBRn6Nee/iU5d1CMIa+CF4w8op3nuCRW1GZrSqjo+XQFH
         scKg0yrcDl+9VnnWdW3M+Q8ZB1dEByn1nto6Y=
MIME-Version: 1.0
In-Reply-To: <AANLkTikUkrAyZiuG_alemWfR6pbcoKrCtL6rG9KBLRzb@mail.gmail.com>
References: <AANLkTikUkrAyZiuG_alemWfR6pbcoKrCtL6rG9KBLRzb@mail.gmail.com>
From: Shihping <c64683@gmail.com>
Date: Fri, 25 Jun 2010 14:12:40 +0800
Message-ID: <AANLkTikUCtqrjkqALYqtZLEQFf3Q7MI_nzJlXsr5wjzn@mail.gmail.com>
Subject: [KERNEL-2.6.34] load dmatest got "__dma_request_channel (fail)" dmesg
To: linux kernel mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I try to load dmatest module in linux-2.6.34 on Ubuntu x86_64 Server system
but when I loaded dmatest module, I got "__dma_request_channel:fall
((null))"  message.
It seems unable to allocate DMA channel.

But I found /proc/dma was registed to cascade mode like
# cat /proc/dma
 4:cascade

So I thought DMA channel should be registed by DMA controller in ICH
successfully. right?

My plaform use Intel E5100(San Clemente) and ICH9R chipset,there were
2 DMA controller was embedded in ICH9R chip.
Is dmatest module not work with ICH9R ? or some other reason cause this?

Sorry about my poor English, and thanks for your answers and responses


Shihping Chen
