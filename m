Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab0FOLpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:45:38 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36257 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726Ab0FOLpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:45:36 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jun 2010 07:45:35 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=M9k7DR0BTwisI37iQT1BVSpB0PzdpAp7Qias52JNejCGS1qjLnXwWRmqKOPkWGui7l
         BbGzCNMNDRTG/heF7SzGR1inxO87Y3KnG+UtWI7MeHoOFNZGrFkKChWzymc4PUcLtutd
         qKIaO3wIyKVgqMQYnNuBsfdCmRBz4DlyVoB6E=
MIME-Version: 1.0
In-Reply-To: <4C176148.4020507@gmail.com>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
	<002001cb0c75$0a54fd00$1efef700$%kim@samsung.com>
	<AANLkTil7gb7SjrYPrHPfSomwxLlHpowXOZd_Qr125jvr@mail.gmail.com>
	<4C176148.4020507@gmail.com>
Date: Tue, 15 Jun 2010 20:39:43 +0900
Message-ID: <AANLkTil7b5Pg5q18eGvGY_cFH75rdpSuZhigH4vcjrnu@mail.gmail.com>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 
	PrimeCells
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Maurus Cuelenaere <mcuelenaere@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Dan Williams <dan.j.williams@intel.com>,
       linux-arm-kernel@lists.infradead.org, yuanyabin1978@sina.com,
       Viresh Kumar <viresh.kumar@st.com>, Alessandro Rubini <rubini@unipv.it>,
       linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
       Peter Pearse <peter.pearse@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 8:17 PM, Maurus Cuelenaere
<mcuelenaere@gmail.com> wrote:
> Op 15-06-10 12:45, Jassi Brar schreef:
>> On Tue, Jun 15, 2010 at 7:25 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
>>> Linus Walleij wrote:
>>>>
>>>> This creates a DMAengine driver for the ARM PL080/PL081 PrimeCells
>>>> based on the implementation earlier submitted by Peter Pearse.
>>>> This is working like a charm for memcpy on the PB11MPCore, but
>>>> slave DMA to devices is still not working.
>>>>
>>>> This DMA controller is used in mostly unmodified form in the ARM
>>>> RealView and Versatile platforms, in the ST-Ericsson Nomadik, and
>>>> in the ST SPEAr platform.
>>>>
>>>> It has been converted to use the header from the Samsung PL080
>>>> derivate instead of its own defintions, and can potentially support
>>>> several controllers in the same system.
>>>>
>>>> Cc: Peter Pearse <peter.pearse@arm.com>
>>>> Cc: Ben Dooks <ben-linux@fluff.org>
>>>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>>>
>>> Looks good, but please give me some time to test on the board(SMDK6410).
>>> If any problem, let you know. Of course no problem, will ack.
>> Samsung doesn't use the DMA API, so this driver is unlikely to work.
>
> It doesn't indeed, but it could be adapted to be a wrapper around the DMA engine API.
> Or even better, the drivers could be adapted to use that API.
I don't particularly like the idea of making Samsung's drivers use the DMA API.
IMHO the S3C dma api is better atm.
