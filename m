Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab0FOKpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 06:45:49 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44438 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378Ab0FOKpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 06:45:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CDebYeZycZaxg3UcozbDUEOaxQchS7o6unLS8cX39l4kdzHo2JiAINT+LCQCPwifBr
         iMHQtRNRD0uwCuqeiQruBMqDtBaxSTycDfXQm+zqJZynRwaJ859H91UeZy0ddr2TVbjV
         ru88J6DzkFx6hAdGxF0MJokN7JrB4Ml4f66J4=
MIME-Version: 1.0
In-Reply-To: <002001cb0c75$0a54fd00$1efef700$%kim@samsung.com>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
	<002001cb0c75$0a54fd00$1efef700$%kim@samsung.com>
Date: Tue, 15 Jun 2010 19:45:45 +0900
Message-ID: <AANLkTil7gb7SjrYPrHPfSomwxLlHpowXOZd_Qr125jvr@mail.gmail.com>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 
	PrimeCells
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Dan Williams <dan.j.williams@intel.com>,
       linux-arm-kernel@lists.infradead.org, yuanyabin1978@sina.com,
       Viresh Kumar <viresh.kumar@st.com>, Alessandro Rubini <rubini@unipv.it>,
       linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
       Peter Pearse <peter.pearse@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 7:25 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Linus Walleij wrote:
>>
>> This creates a DMAengine driver for the ARM PL080/PL081 PrimeCells
>> based on the implementation earlier submitted by Peter Pearse.
>> This is working like a charm for memcpy on the PB11MPCore, but
>> slave DMA to devices is still not working.
>>
>> This DMA controller is used in mostly unmodified form in the ARM
>> RealView and Versatile platforms, in the ST-Ericsson Nomadik, and
>> in the ST SPEAr platform.
>>
>> It has been converted to use the header from the Samsung PL080
>> derivate instead of its own defintions, and can potentially support
>> several controllers in the same system.
>>
>> Cc: Peter Pearse <peter.pearse@arm.com>
>> Cc: Ben Dooks <ben-linux@fluff.org>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>
> Looks good, but please give me some time to test on the board(SMDK6410).
> If any problem, let you know. Of course no problem, will ack.
Samsung doesn't use the DMA API, so this driver is unlikely to work.
