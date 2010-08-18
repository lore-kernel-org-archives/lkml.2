Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab0HRJSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 05:18:42 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:45834 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040Ab0HRJSi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 05:18:38 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Dan Williams <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "yuanyabin1978@sina.com" <yuanyabin1978@sina.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 18 Aug 2010 11:18:00 +0200
Subject: RE: [PATCH 1/5] ARM: add PrimeCell generic DMA to PL022 v9
Thread-Topic: [PATCH 1/5] ARM: add PrimeCell generic DMA to PL022 v9
Thread-Index: Acs+jquf9Nqkt6A4Q5eKlZJ1cEDRnwAJ4Cmg
Message-ID: <CEE6BB42CAD6E947908279175AF8470A0267540DE4@EXDCVYMBSTM006.EQ1STM.local>
References: <1281095419-15600-1-git-send-email-linus.walleij@stericsson.com>
 <20100817044834.GA27060@angua.secretlab.ca>
 <AANLkTi=vCb8rQu3KPcCv7cP94ovQ_ZFrs7aBjGYtPQmy@mail.gmail.com>
In-Reply-To: <AANLkTi=vCb8rQu3KPcCv7cP94ovQ_ZFrs7aBjGYtPQmy@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Grant]

> This patch causes the following build error and warnings.  The
> warnings are simple init annotation mismatches.  I haven't dug into
> the error, but I suspect the driver needs to depend on or select
> another config symbol.  I'm dropping it from my tree.

OK I'll cook up a new one with all the fixes and fix this stuff
too....

Yours,
Linus Walleij
