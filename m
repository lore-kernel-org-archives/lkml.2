Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab2BAJvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 04:51:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab2BAJvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 04:51:07 -0500
Message-ID: <4F290B9E.1090605@redhat.com>
Date: Wed, 01 Feb 2012 17:53:34 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] move vm tools from Documentation/vm/ to tools/
References: <20120201063420.GA10204@darkstar.nay.redhat.com> <CAOJsxLGVS3bK=hiKJu4NwTv-Nf8TCSAEL4reSZoY4=44hPt8rA@mail.gmail.com> <4F28EC9D.7000907@redhat.com> <20120201083032.GA6774@localhost>
In-Reply-To: <20120201083032.GA6774@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 04:30 PM, Wu Fengguang wrote:

> On Wed, Feb 01, 2012 at 03:41:17PM +0800, Dave Young wrote:
>> On 02/01/2012 03:32 PM, Pekka Enberg wrote:
>>
>>> On Wed, Feb 1, 2012 at 8:34 AM, Dave Young <dyoung@redhat.com> wrote:
>>>> tools/ is the better place for vm tools which are used by many people.
>>>> Moving them to tools also make them open to more users instead of hide in
>>>> Documentation folder.
>>>
>>> For moving the code:
>>>
>>> Acked-by: Pekka Enberg <penberg@kernel.org>
> 
> I have no problem with the move -- actually I sent a similar patch
> long time ago to Andrew ;)


Good to know, then do you mind I add your signed-off line?

> 
> Will git-mv end up with a better commit?
> 
>>>> Also fixed several coding style problem.
>>>
>>> Can you please make that a separate patch?
>>
>>
>> Will do.
>>
>> BTW, I think tools/slub/slabinfo.c should be included in tools/vm/ as
>> well, will move it in v2 patch
> 
> CC Christoph. Maybe not a big deal since it's already under tools/.
> 
> Thanks,
> Fengguang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks
Dave
