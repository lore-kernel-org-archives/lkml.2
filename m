Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab1CNMfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 08:35:09 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:58182 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752031Ab1CNMfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 08:35:06 -0400
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "dtor@mail.ru" <dtor@mail.ru>, "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 Mar 2011 05:34:08 -0700
Subject: RE: [PATCH] mfd: pxa-w1: MFD driver for PXA 1wire control + DS1WM
 chip
Thread-Topic: [PATCH] mfd: pxa-w1: MFD driver for PXA 1wire control + DS1WM
 chip
Thread-Index: AcviOvmQ6K5EANjdQ22g6tWEQIwe6gACLnrg
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05CEAFFB95@SC-VEXCH1.marvell.com>
References: <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-4-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-5-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-6-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-7-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-8-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-9-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-10-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-11-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-12-git-send-email-haojian.zhuang@marvell.com>
 <20110314112838.GK31153@sortiz-mobl>
In-Reply-To: <20110314112838.GK31153@sortiz-mobl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: Al82 DSRo KWnQ RU0D eF9U hpm1 vZ6E ACyHUQ== AC1Rtw==
 AD4q4Q== AIPBgQ== AJs3ZQ== AJ2GLg== AJ/MvQ== AKvNWw==
 AL8kuQ==;9;YQAuAHoAdQBtAG0AbwBAAHQAbwB3AGUAcgB0AGUAYwBoAC4AaQB0ADsAYgByAG8AbwBuAGkAZQBAAG8AcABlAG4AcwBvAHUAcgBjAGUALgB3AG8AbABmAHMAbwBuAG0AaQBjAHIAbwAuAGMAbwBtADsAZABtAGkAdAByAHkALgB0AG8AcgBvAGsAaABvAHYAQABnAG0AYQBpAGwALgBjAG8AbQA7AGQAdABvAHIAQABtAGEAaQBsAC4AcgB1ADsAagBvAGgAbgBwAG8AbABAADIAawBhAC4AbQBpAHAAdAAuAHIAdQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAHIAZwBAAHMAbABpAG0AbABvAGcAaQBjAC4AYwBvAC4AdQBrADsAcgBwAHUAcgBkAGkAZQBAAHIAcABzAHkAcwAuAG4AZQB0ADsAcwBhAG0AZQBvAEAAbABpAG4AdQB4AC4AaQBuAHQAZQBsAC4AYwBvAG0A;Sosha1_v1;7;{6976EA08-2F96-4CFE-A4EF-8EB6C5133491};aAB6AGgAdQBhAG4AZwAxAEAAbQBhAHIAdgBlAGwAbAAuAGMAbwBtAA==;Mon,
 14 Mar 2011 12:34:08
 GMT;UgBFADoAIABbAFAAQQBUAEMASABdACAAbQBmAGQAOgAgAHAAeABhAC0AdwAxADoAIABNAEYARAAgAGQAcgBpAHYAZQByACAAZgBvAHIAIABQAFgAQQAgADEAdwBpAHIAZQAgAGMAbwBuAHQAcgBvAGwAIAArACAARABTADEAVwBNACAAYwBoAGkAcAA=
x-cr-puzzleid: {6976EA08-2F96-4CFE-A4EF-8EB6C5133491}
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2ECZIM8023055



>-----Original Message-----
>From: Samuel Ortiz [mailto:sameo@linux.intel.com]
>Sent: 2011ƒÍ3‘¬14»’ 7:29 PM
>To: Haojian Zhuang
>Cc: johnpol@2ka.mipt.ru; a.zummo@towertech.it; lrg@slimlogic.co.uk;
>broonie@opensource.wolfsonmicro.com; dmitry.torokhov@gmail.com;
>dtor@mail.ru; rpurdie@rpsys.net; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] mfd: pxa-w1: MFD driver for PXA 1wire control +
>DS1WM chip
>
>Hi Haojian,
>
>On Mon, Mar 07, 2011 at 11:43:20PM +0800, Haojian Zhuang wrote:
>> This driver provides registers and IRQ of PXA3xx chips to the ds1wm
>driver.
>Why is this an MFD driver ?
>
>Cheers,
>Samuel.
>
>--
>Intel Open Source Technology Centre
>http://oss.intel.com/

Hi Samuel,

Because there's already a DS1WM driver in drivers/w1/masters/ds1wm.c. In PXA silicons, W1 controler is compatible with this driver. So we implement it as MFD driver, like htc-pasic3.c.

Best Regards
Haojian
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
