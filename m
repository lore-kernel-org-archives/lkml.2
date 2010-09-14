Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab0INTcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:32:13 -0400
Received: from freeflow.nu ([178.79.134.28]:49949 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab0INTcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:32:11 -0400
Message-ID: <4C8FCDB8.3030800@kernel.org>
Date: Tue, 14 Sep 2010 22:32:08 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2 1/2] SLUB: Fix merged slab cache names
References: <1284490101-2362-1-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1009141357160.444@router.home>
In-Reply-To: <alpine.DEB.2.00.1009141357160.444@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 14.9.2010 21.59, Christoph Lameter wrote:
> On Tue, 14 Sep 2010, Pekka Enberg wrote:
>
>> @@ -3211,6 +3225,7 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
>>   		size_t align, unsigned long flags, void (*ctor)(void *))
>>   {
>>   	struct kmem_cache *s;
>> +	char *dup_name;
> Dont like the name. Its a short lived variables. So "n"?
>
> Otherwise
>
> Acked-by: Christoph Lameter<cl@linux.com>
>
Fixed.
