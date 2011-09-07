Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1IGT1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:27:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63290 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab1IGT1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:27:50 -0400
MIME-Version: 1.0
In-Reply-To: <438BB0150E931F4B9CE701519A4463010871804A46@bgsmsx502.gar.corp.intel.com>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com>
	<438BB0150E931F4B9CE701519A4463010871804A46@bgsmsx502.gar.corp.intel.com>
Date: Wed, 7 Sep 2011 21:27:49 +0200
Message-ID: <CAKnu2MrFMGUTn+DTKJaOmRALCadia8wSCKVTQVn6PPFAHuvayg@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "workgroup.linux@csr.com" <workgroup.linux@csr.com>,
        "rongjun.ying@csr.com" <rongjun.ying@csr.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/7 Koul, Vinod <vinod.koul@intel.com>:
> On Tue, 2011-09-06 at 22:41 -0700, Barry Song wrote:
>
>> +config SIRF_DMA
>> +     tristate "CSR SiRFprimaII DMA support"
>> +     depends on ARCH_PRIMA2
>> +     select DMA_ENGINE
>> +     help
>> +       Enable support for the CSR SiRFprimaII DMA engine.
>
> How different is it from the other primacell based DMA drivers, and why
> wouldn't it make sense to use/modify one of them?

Hehe it looks to me like primall has no relation to PrimeCell, just
confusingly similar names :-)

Yours,
Linus Walleij
