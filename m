Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab0HJVRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 17:17:51 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54205 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab0HJVRs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:17:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f7rhaIX2MLvkxk/zzHSnf/AzaDuHuzW6PBOrIL6jLLg4BXVtj5WbPaBOPcbFS0mpxE
         tXd1JucRcinbdE1c1OW5Elhanf/taN8m6gErMq51yz04u86lwsW0qYC1beYWa+f3Hih9
         WOAJITcLH72DLlp+GLjqs5ITmtzzH4s2Vk5mw=
MIME-Version: 1.0
In-Reply-To: <20100810131032.GI27749@pengutronix.de>
References: <20100810131032.GI27749@pengutronix.de>
Date: Tue, 10 Aug 2010 23:17:40 +0200
Message-ID: <AANLkTini2BJr9x5-03MV1wFTUH4M+REzOwxUS_Cc_sHc@mail.gmail.com>
Subject: Re: dmaengine cyclic transfers
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/10 Sascha Hauer <s.hauer@pengutronix.de>:

> Author: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> Date:   Wed Apr 1 15:47:02 2009 +0200
>
>    dw_dmac: add cyclic API to DW DMA driver
>
> This could be very useful for the SDMA engine aswell. What are the
> reasons this is not implemented in the generic dmaengine API but as
> an extension to a specific driver?

No reasons what I know. There was a similar code snippet in Peter
Pearse's PL08x driver as well, I just didn't know what to do with it.

> Should I also implement it like
> this or isn't it better to extend the dmaengine itself?

This is going to be generally useful, so please extend the DMAengine
if I have my say. I actually miss two functions from the engine:

1) Single buffer slave transfers (without sglist)
2) Cyclic buffers (esp good for audio)

The first I have a patch for, will repost.

Yours,
Linus Walleij
