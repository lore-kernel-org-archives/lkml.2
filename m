Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab1A0BFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 20:05:25 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:37356 "HELO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754254Ab1A0BFY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 20:05:24 -0500
From: Philip Rakity <prakity@marvell.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: Chris Ball <cjb@laptop.org>, Kyungmin Park <kmpark@infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrew.chih.howe.khor@intel.com" <andrew.chih.howe.khor@intel.com>,
        "kok.howg.ewe@intel.com" <kok.howg.ewe@intel.com>
Date: Wed, 26 Jan 2011 17:03:45 -0800
Subject: Re: A MMC card transfer issue
Thread-Topic: A MMC card transfer issue
Thread-Index: Acu9vgyvaZxGXq+VT9eBBSUDjufEQQ==
Message-ID: <6076934B-27C2-4766-B101-793C7447C71C@marvell.com>
References: <4CD8DE9C.4040505@dsn.okisemi.com>
 <AANLkTimfnj8GcSwmALjaZUBsiq6ssaVuzVZZsZHRYmiX@mail.gmail.com>
 <001701cb814c$71926bf0$66f8800a@maildom.okisemi.com>
 <001201cb90f4$4be8f790$66f8800a@maildom.okisemi.com>
 <2D50F985-2383-4406-8514-DFE462A5F546@marvell.com>
 <4D2E0464ABB54FFF9C10583336E27879@hacdom.okisemi.com>
 <4C4E7DE5-7CF1-4D97-9CAD-F600FCBE477A@marvell.com>
 <20110119174233.GA30494@void.printf.net>
 <F6E8C422FB8A4D78A5BDF7B6ECDA1E00@hacdom.okisemi.com>
 <D8E7AFC5-6B9E-414E-81A8-292FCD2F6E3C@marvell.com>
 <629816F753974155B62FF8FA718A26CA@hacdom.okisemi.com>
In-Reply-To: <629816F753974155B62FF8FA718A26CA@hacdom.okisemi.com>
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


yes

you need to have the driver or the low level code enable this QUIRK.

which mmc driver are you using.

On Jan 26, 2011, at 5:00 PM, Tomoya MORINAGA wrote:

> Hi Philip,
> 
> On Thursday, January 27, 2011 12:42 AM, Philip Rakity wrote:
>> Did you define the CAP for BUS WIDTH ? 
>> 
>> MMC_CAP_BUS_WIDTH_TEST 
>> 
>> in the driver or the platform driver ?
> 
> Let me make the above meaning clear.
> 
> I don't modify kernel source code "drivers/mmc" at all
> Is the above mean I must modify something kernel source code ?
> 
> Thanks,
> -----------------------------------------
> Tomoya MORINAGA
> OKI SEMICONDUCTOR CO., LTD.
> 

