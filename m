Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab1IUSBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 14:01:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58529 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab1IUSA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 14:00:58 -0400
MIME-Version: 1.0
In-Reply-To: <4E7A084C.3000304@xenotime.net>
References: <20110920173102.d38155c7defbbc29beaae7c0@canb.auug.org.au>
	<4E78CFC0.4020003@xenotime.net>
	<CACna6rxGrd-ORWZrc0xsAOKptU_Xj3eGh9qSfX9vJYCPTZrCRg@mail.gmail.com>
	<4E78FCDB.1010002@xenotime.net>
	<CACna6rywFitSNkkwo6tNy887vdsoyHG5Cadk6Bb8_qBJ+gc42w@mail.gmail.com>
	<4E7A084C.3000304@xenotime.net>
Date: Wed, 21 Sep 2011 20:00:57 +0200
Message-ID: <CACna6ryNw+YgTiO5dBSGcTfUabM_yO0LaSsbGpC_X6JrQudnBQ@mail.gmail.com>
Subject: Re: [PATCH -next v2] bcma: driver_chipcommon_pmu.c needs linux/export.h
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 21 września 2011 17:52 użytkownik Randy Dunlap
<rdunlap@xenotime.net> napisał:
> On 09/20/2011 11:45 PM, Rafał Miłecki wrote:
>> W dniu 20 września 2011 22:51 użytkownik Randy Dunlap
>> <rdunlap@xenotime.net> napisał:
>>> From: Randy Dunlap <rdunlap@xenotime.net>
>>>
>>> bcma/driver_chipcommon_pmu.c needs to include <linux/export.h>
>>> to fix these warnings:
>>>
>>> drivers/bcma/driver_chipcommon_pmu.c:27:1: warning: data definition has no type or storage class
>>> drivers/bcma/driver_chipcommon_pmu.c:27:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
>>> drivers/bcma/driver_chipcommon_pmu.c:27:1: warning: parameter names (without types) in function declaration
>>
>> Don't you get the same warning for core.c? Weird...
>
> No, I don't.  Stranger things have happened, I'm sure.
>
> Feel free to add export.h to other files, or do you want me
> to do that?

Please do that while you're hacking that include anyway.

-- 
Rafał
