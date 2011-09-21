Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab1IUPws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:52:48 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:58939 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752500Ab1IUPwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:52:46 -0400
Message-ID: <4E7A084C.3000304@xenotime.net>
Date: Wed, 21 Sep 2011 08:52:44 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH -next v2] bcma: driver_chipcommon_pmu.c needs linux/export.h
References: <20110920173102.d38155c7defbbc29beaae7c0@canb.auug.org.au>	<4E78CFC0.4020003@xenotime.net>	<CACna6rxGrd-ORWZrc0xsAOKptU_Xj3eGh9qSfX9vJYCPTZrCRg@mail.gmail.com>	<4E78FCDB.1010002@xenotime.net> <CACna6rywFitSNkkwo6tNy887vdsoyHG5Cadk6Bb8_qBJ+gc42w@mail.gmail.com>
In-Reply-To: <CACna6rywFitSNkkwo6tNy887vdsoyHG5Cadk6Bb8_qBJ+gc42w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 11:45 PM, Rafał Miłecki wrote:
> W dniu 20 września 2011 22:51 użytkownik Randy Dunlap
> <rdunlap@xenotime.net> napisał:
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> bcma/driver_chipcommon_pmu.c needs to include <linux/export.h>
>> to fix these warnings:
>>
>> drivers/bcma/driver_chipcommon_pmu.c:27:1: warning: data definition has no type or storage class
>> drivers/bcma/driver_chipcommon_pmu.c:27:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
>> drivers/bcma/driver_chipcommon_pmu.c:27:1: warning: parameter names (without types) in function declaration
> 
> Don't you get the same warning for core.c? Weird...

No, I don't.  Stranger things have happened, I'm sure.

Feel free to add export.h to other files, or do you want me
to do that?


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
