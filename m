Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab0ELHYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 03:24:34 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:46896 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751381Ab0ELHYc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 03:24:32 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 May 2010 09:24:06 +0200
Subject: RE: [PATCH 1/7] DMAENGINE: add generic PrimeCell interface to COH
 901 	318 v6
Thread-Topic: [PATCH 1/7] DMAENGINE: add generic PrimeCell interface to COH
 901 	318 v6
Thread-Index: AcrxKEhz2vLOp4E0Rb28SfEDYWbDCwAe5H2w
Message-ID: <CEE6BB42CAD6E947908279175AF8470A025A6DE7DA@EXDCVYMBSTM006.EQ1STM.local>
References: <1272848076-28315-1-git-send-email-linus.walleij@stericsson.com>
 <AANLkTinAVhnpjgVTtbZYYKb1t_DInVwTKkkJRzcO97RX@mail.gmail.com>
In-Reply-To: <AANLkTinAVhnpjgVTtbZYYKb1t_DInVwTKkkJRzcO97RX@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dan]

> What happens when two primecell dma devices are present on one soc?
> Can that happen?

Of course it can happen. In theory... There is no such system that
I'm aware of.

Peter's PL08x driver even model the PL08x as a singleton, i.e. a
static struct in the driver file.

> In that case we'll have conflicting providers of
> dma_set_ambaconfig().

Yes...

Linus
