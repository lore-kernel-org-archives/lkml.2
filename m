Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161247Ab2COTMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:12:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:56250 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420Ab2COTMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:12:48 -0400
Message-ID: <4F623ED3.1050003@windriver.com>
Date: Thu, 15 Mar 2012 15:11:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: =?UTF-8?B?7ZWo66qF7KO8?= <myungjoo.ham@samsung.com>,
        Jesper Juhl <jj@chaosbits.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>,
        Axel Lin <axel.lin@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] power, max8998: Include linux/module.h just once in drivers/power/max8998_charger.c
References: <32079635.330331328493473417.JavaMail.weblogic@epml22> <20120315171700.GE11441@oksana.dev.rtsoft.ru>
In-Reply-To: <20120315171700.GE11441@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-03-15 01:17 PM, Anton Vorontsov wrote:
> On Mon, Feb 06, 2012 at 01:57:54AM +0000, 함명주 wrote:
>>> Remove the duplicate.
>>>
>>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>>
>> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> 
> Applied, thanks!

There is already a commit queued in linux-next that deletes
all the duplicates at once.  It just so happens to delete
the other instance vs the one shown here.  So if both
commits are present, then there won't be *any* module.h
left, and the build will fail.  If it is possible, please
just drop this patch, since the treewide duplicate patch
will still have to exist to fix the other instances.

https://lkml.org/lkml/2012/2/29/586

Thanks,
Paul.

> 
>>
>>> ---
>>>  drivers/power/max8998_charger.c |    1 -
>>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/power/max8998_charger.c b/drivers/power/max8998_charger.c
>>> index 9b3f2bf..5c5f281 100644
>>> --- a/drivers/power/max8998_charger.c
>>> +++ b/drivers/power/max8998_charger.c
>>> @@ -21,7 +21,6 @@
>>>  
>>>  #include <linux/module.h>
>>>  #include <linux/err.h>
>>> -#include <linux/module.h>
>>>  #include <linux/slab.h>
>>>  #include <linux/platform_device.h>
>>>  #include <linux/power_supply.h>
>>> -- 
>>> 1.7.9
> 
