Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab1IHBrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 21:47:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33697 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab1IHBrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 21:47:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAKnu2MrFMGUTn+DTKJaOmRALCadia8wSCKVTQVn6PPFAHuvayg@mail.gmail.com>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com>
 <438BB0150E931F4B9CE701519A4463010871804A46@bgsmsx502.gar.corp.intel.com> <CAKnu2MrFMGUTn+DTKJaOmRALCadia8wSCKVTQVn6PPFAHuvayg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 8 Sep 2011 09:47:18 +0800
Message-ID: <CAGsJ_4wuFeLNPhQc5SsgfFXbNOq9N8hPaBNQX2ChZfgb=n6asw@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "workgroup.linux@csr.com" <workgroup.linux@csr.com>,
        "rongjun.ying@csr.com" <rongjun.ying@csr.com>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/8 Linus Walleij <linus.ml.walleij@gmail.com>:
> 2011/9/7 Koul, Vinod <vinod.koul@intel.com>:
>> On Tue, 2011-09-06 at 22:41 -0700, Barry Song wrote:
>>
>>> +config SIRF_DMA
>>> +     tristate "CSR SiRFprimaII DMA support"
>>> +     depends on ARCH_PRIMA2
>>> +     select DMA_ENGINE
>>> +     help
>>> +       Enable support for the CSR SiRFprimaII DMA engine.
>>
>> How different is it from the other primacell based DMA drivers, and why
>> wouldn't it make sense to use/modify one of them?
>
> Hehe it looks to me like primall has no relation to PrimeCell, just
> confusingly similar names :-)

yes. only with the word "prima", which is the mach name. it has
nothing to do with primecell.
>
> Yours,
> Linus Walleij
-barry
