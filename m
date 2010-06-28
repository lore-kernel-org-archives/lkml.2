Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab0F1KOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 06:14:14 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34454 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0F1KOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 06:14:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=Apa7jg7lihiOGOxiq4EFrq8hQCxk1kiHW5jeOeqAayfpv2OiH9C7HcLag2/vipx8BW
         fkTiUI62klcwAA8Ggc6WVNvdRTqTA0/GdTTKit0rtCb/j+8IOwe4UKu0tk8x6t2NS2EP
         XsezCwoSHxXZeGOCuvNiLSl+F5yIsEfwqy6nk=
MIME-Version: 1.0
From: Shihping <c64683@gmail.com>
Date: Mon, 28 Jun 2010 18:06:55 +0800
Message-ID: <AANLkTikzAHUU9MK53osJm_sw4tmXFkzz-_ox3pAzjMQg@mail.gmail.com>
Subject: dmatest:got "__dma_request_channel (fail)" dmesg
To: linux kernel mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I try to load dmatest module in linux-2.6.34 on Ubuntu x86_64 Server
system but when I loaded dmatest module, I got
"__dma_request_channel:fall ((null))"  message.
It seems unable to allocate DMA channel.

But I found /proc/dma was registed to cascade mode like # cat /proc/dma
 4:cascade

So I thought DMA channel should be registed by DMA controller in ICH
successfully. right?

My plaform use Intel E5100(San Clemente) and ICH9R chipset,there were
2 DMA controller was embedded in ICH9R chip.
Is dmatest module not work with ICH9R ? or some other reason cause this?

Sorry about my poor English, and thanks for your answers and responses


Shihping Chen
