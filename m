Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab0FOLRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:17:36 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:53094 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab0FOLRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:17:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=RO/VzqJUy84XTz3QI+7Aio7GKiso/cvdX6O+bLiYguTY1BCfGUvN2vw3ojcJQq+WgA
         Y9w5dbNGQ0xsyXwaQ0oRxiHy5MPp3FEB/xIf00bYxaIe7mPXXnyKN/OrRaQJcAssM7vd
         5xXLS1FarZwx68wHQwU3e+WttN4ywDvTgpMWc=
Message-ID: <4C176148.4020507@gmail.com>
Date: Tue, 15 Jun 2010 13:17:28 +0200
From: Maurus Cuelenaere <mcuelenaere@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; nl; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.ports.arm.kernel
To: Jassi Brar <jassisinghbrar@gmail.com>
CC: Kukjin Kim <kgene.kim@samsung.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Dan Williams <dan.j.williams@intel.com>,
       linux-arm-kernel@lists.infradead.org, yuanyabin1978@sina.com,
       Viresh Kumar <viresh.kumar@st.com>, Alessandro Rubini <rubini@unipv.it>,
       linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
       Peter Pearse <peter.pearse@arm.com>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081  PrimeCells
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>	<002001cb0c75$0a54fd00$1efef700$%kim@samsung.com> <AANLkTil7gb7SjrYPrHPfSomwxLlHpowXOZd_Qr125jvr@mail.gmail.com>
In-Reply-To: <AANLkTil7gb7SjrYPrHPfSomwxLlHpowXOZd_Qr125jvr@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 15-06-10 12:45, Jassi Brar schreef:
> On Tue, Jun 15, 2010 at 7:25 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
>> Linus Walleij wrote:
>>>
>>> This creates a DMAengine driver for the ARM PL080/PL081 PrimeCells
>>> based on the implementation earlier submitted by Peter Pearse.
>>> This is working like a charm for memcpy on the PB11MPCore, but
>>> slave DMA to devices is still not working.
>>>
>>> This DMA controller is used in mostly unmodified form in the ARM
>>> RealView and Versatile platforms, in the ST-Ericsson Nomadik, and
>>> in the ST SPEAr platform.
>>>
>>> It has been converted to use the header from the Samsung PL080
>>> derivate instead of its own defintions, and can potentially support
>>> several controllers in the same system.
>>>
>>> Cc: Peter Pearse <peter.pearse@arm.com>
>>> Cc: Ben Dooks <ben-linux@fluff.org>
>>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>>
>> Looks good, but please give me some time to test on the board(SMDK6410).
>> If any problem, let you know. Of course no problem, will ack.
> Samsung doesn't use the DMA API, so this driver is unlikely to work.

It doesn't indeed, but it could be adapted to be a wrapper around the DMA engine API.
Or even better, the drivers could be adapted to use that API.
