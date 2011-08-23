Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab1HWPfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:35:00 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52319 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab1HWPew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:34:52 -0400
Message-ID: <4E53C88D.2050909@linux.vnet.ibm.com>
Date: Tue, 23 Aug 2011 10:34:37 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: gregkh@suse.de, ascardo@holoscopio.com, rdunlap@xenotime.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: zcache: fix typos
References: <1314039008-8845-1-git-send-email-sjenning@linux.vnet.ibm.com> <319475b8-897e-4c32-b781-2c86541f0753@default>
In-Reply-To: <319475b8-897e-4c32-b781-2c86541f0753@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 10:17 AM, Dan Magenheimer wrote:
>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>> Sent: Monday, August 22, 2011 12:50 PM
>> To: gregkh@suse.de
>> Cc: ascardo@holoscopio.com; Dan Magenheimer; sjenning@linux.vnet.ibm.com; rdunlap@xenotime.net;
>> devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
>> Subject: [PATCH] staging: zcache: fix typos
>>
>> The patch fixes two typos in zcache-main.c
>>
>> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> 
> Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> 
> Seth, I'm not very familiar with the process but I think this
> kind of patch can go through the trivial patch monkey. See
> Documentation/SubmittingPatches.
> 

Didn't know about that.  I'll cc that in the future on patches
like this. Thanks for the tip.

>> ---
>>  drivers/staging/zcache/zcache-main.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
>> index 855a5bb..82054c9 100644
>> --- a/drivers/staging/zcache/zcache-main.c
>> +++ b/drivers/staging/zcache/zcache-main.c
>> @@ -651,7 +651,7 @@ static unsigned int zv_max_zsize = (PAGE_SIZE / 8) * 7;
>>  /*
>>   * byte count defining poor *mean* compression; pages with greater zsize
>>   * will be rejected until sufficient better-compressed pages are accepted
>> - * driving the man below this threshold
>> + * driving the mean below this threshold
>>   */
>>  static unsigned int zv_max_mean_zsize = (PAGE_SIZE / 8) * 5;
>>
>> @@ -1993,7 +1993,7 @@ static int __init zcache_init(void)
>>  		pr_info("zcache: frontswap enabled using kernel "
>>  			"transcendent memory and xvmalloc\n");
>>  		if (old_ops.init != NULL)
>> -			pr_warning("ktmem: frontswap_ops overridden");
>> +			pr_warning("zcache: frontswap_ops overridden");
>>  	}
>>  #endif
>>  out:
>> --
>> 1.7.4.1
>>

