Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab1ITUnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 16:43:21 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:48721 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751023Ab1ITUnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 16:43:19 -0400
Message-ID: <4E78FAE6.6080903@xenotime.net>
Date: Tue, 20 Sep 2011 13:43:18 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH -next] bcma: needs export.h
References: <20110920173102.d38155c7defbbc29beaae7c0@canb.auug.org.au>	<4E78CFC0.4020003@xenotime.net> <CACna6rxGrd-ORWZrc0xsAOKptU_Xj3eGh9qSfX9vJYCPTZrCRg@mail.gmail.com>
In-Reply-To: <CACna6rxGrd-ORWZrc0xsAOKptU_Xj3eGh9qSfX9vJYCPTZrCRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 11:45 AM, Rafał Miłecki wrote:
> 2011/9/20 Randy Dunlap <rdunlap@xenotime.net>:
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> bcma/driver_chipcommon_pmu.c needs to include <linux/export.h>,
>> so add it to the headers that are included by bcma_private.h.
> 
> Please take a look at discussion in:
> [PATCH -next] bcma: main.c needs to include <linux/slab.h>
> thread (by Andrew).
> 
> I believe that according to the discussion, such a includes should be
> done in .c files.
> 
> Andrew: can you comment? Am I right?


Sure, I'll resubmit the patch.

Is there already a patch to remove <linux/delay.h> from bcma_private.h ?

bcma_private.h uses __init & __exit, so it should #include <linux/init.h> ...


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
