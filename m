Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1AZPmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:42:17 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:52269 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752705Ab1AZPmQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:42:16 -0500
From: Philip Rakity <prakity@marvell.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: Chris Ball <cjb@laptop.org>, Kyungmin Park <kmpark@infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrew.chih.howe.khor@intel.com" <andrew.chih.howe.khor@intel.com>,
        "kok.howg.ewe@intel.com" <kok.howg.ewe@intel.com>
Date: Wed, 26 Jan 2011 07:42:07 -0800
Subject: Re: A MMC card transfer issue
Thread-Topic: A MMC card transfer issue
Thread-Index: Acu9b5Z9PsOIE255TBmEwClDphyAsQ==
Message-ID: <D8E7AFC5-6B9E-414E-81A8-292FCD2F6E3C@marvell.com>
References: <4CD8DE9C.4040505@dsn.okisemi.com>
 <AANLkTimfnj8GcSwmALjaZUBsiq6ssaVuzVZZsZHRYmiX@mail.gmail.com>
 <001701cb814c$71926bf0$66f8800a@maildom.okisemi.com>
 <001201cb90f4$4be8f790$66f8800a@maildom.okisemi.com>
 <2D50F985-2383-4406-8514-DFE462A5F546@marvell.com>
 <4D2E0464ABB54FFF9C10583336E27879@hacdom.okisemi.com>
 <4C4E7DE5-7CF1-4D97-9CAD-F600FCBE477A@marvell.com>
 <20110119174233.GA30494@void.printf.net>
 <F6E8C422FB8A4D78A5BDF7B6ECDA1E00@hacdom.okisemi.com>
In-Reply-To: <F6E8C422FB8A4D78A5BDF7B6ECDA1E00@hacdom.okisemi.com>
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


Did you define the CAP for BUS WIDTH ? 

MMC_CAP_BUS_WIDTH_TEST 

in the driver or the platform driver ?

Philip


On Jan 26, 2011, at 12:28 AM, Tomoya MORINAGA wrote:

> On Thursday, January 20, 2011 2:43 AM, Chris Ball wrote
>> So, please re-test against 2.6.38-rc1 and let us know whether 
>> you still have problems.  Thanks,
> I have tested the latest "2.6.38-rc2".
> However, the issue remains to be seen.
> 
> Thanks in advance,
> -----------------------------------------
> Tomoya MORINAGA
> OKI SEMICONDUCTOR CO., LTD.
> 
>> -----Original Message-----
>> From: Chris Ball [mailto:cjb@laptop.org] 
>> Sent: Thursday, January 20, 2011 2:43 AM
>> To: Philip Rakity
>> Cc: Tomoya MORINAGA; Kyungmin Park; 
>> linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org; 
>> andrew.chih.howe.khor@intel.com; kok.howg.ewe@intel.com
>> Subject: Re: A MMC card transfer issue
>> 
>> Hi,
>> 
>> On Tue, Jan 18, 2011 at 10:05:04PM -0800, Philip Rakity wrote:
>>> 
>>> For 1 bit transcend cards you need these 2 patches.
>>> 
>>>> From 22113efd00491310da802f3b1a9a66cfcf415fac Mon Sep 17 00:00:00 
>>>> 2001
>>> From: Aries Lee <arieslee@jmicron.com>
>>> Date: Wed, 15 Dec 2010 08:14:24 +0100
>>> Subject: [PATCH] mmc: Test bus-width for old MMC devices
>> 
>> Present in 2.6.38-rc1.
>> 
>>>> From 08c82dfad2458f8f9b83126224a85e7ea9e2b046 Mon Sep 17 00:00:00 
>>>> 2001
>>> From: Takashi Iwai <tiwai@suse.de>
>>> Date: Wed, 22 Dec 2010 09:59:44 +0100
>>> Subject: [PATCH] mmc: fix mmc_set_bus_width_ddr() call without 
>>> bus-width-test cap
>> 
>> Also present in 2.6.38-rc1.
>> 
>> So, please re-test against 2.6.38-rc1 and let us know whether 
>> you still have problems.  Thanks,
>> 
>> -- 
>> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
>> One Laptop Per Child
>> 
> 

