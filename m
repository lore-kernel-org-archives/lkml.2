Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761716Ab0HFTSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:18:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33150 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0HFTSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:18:32 -0400
Message-ID: <4C5C5D18.6050905@oracle.com>
Date: Fri, 06 Aug 2010 12:06:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, axboe@kernel.dk
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 6 (block git tree)
References: <20100806132758.6001d416.sfr@canb.auug.org.au> <20100806120456.5eca82b7.randy.dunlap@oracle.com>
In-Reply-To: <20100806120456.5eca82b7.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/10 12:04, Randy Dunlap wrote:
> On Fri, 6 Aug 2010 13:27:58 +1000 Stephen Rothwell wrote:
> 
>> Hi all,
>>
>> As the merge window is open, please do not add 2.6.37 material to your
>> linux-next included trees until after 2.6.36-rc1.
>>
>> Changes since 20100805:
>>
>> The block tree lost its build failure and a conflict.
> 
> 
> Lots of source files now need <linux/blk_types.h>:
> 
> mm/filemap.c:2164: error: 'REQ_WRITE' undeclared
> fs/read_write.c:362: error: 'REQ_WRITE' undeclared
> fs/splice.c:1108: error: 'REQ_WRITE' undeclared
> fs/aio.c:1496: error: 'REQ_WRITE' undeclared
> drivers/memstick/core/memstick.c:272: error: 'REQ_WRITE' undeclared
> drivers/memstick/host/tifm_ms.c:218: error: 'REQ_WRITE' undeclared
> drivers/memstick/host/jmb38x_ms.c:333: error: 'REQ_WRITE' undeclared
> drivers/staging/spectra/ffsport.c:277: error: 'REQ_TYPE_LINUX_BLOCK' undeclared
> fs/compat.c:1274: error: 'REQ_WRITE' undeclared


Sorry, I see that this has already been fixed.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
