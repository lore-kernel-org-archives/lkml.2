Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab1DZGHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:07:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50514 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab1DZGHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bZ9yya1GQgH4nIMniiBEmUrClDMG+pejix+os7zHaZjnO0nmOd+0liLF9J42mCVPpv
         cJnR+aIXNLpC021v7pqqKwxK8k2wW0rSbYL7Y5/ayhznUfebo8uwqQhMeDRxsklizylR
         IiazMBB5wbvf2WJY4YTXx3lK9JJfPed9NRL+g=
MIME-Version: 1.0
In-Reply-To: <BANLkTik8k9A8N8CPk+eXo9c_syxJFRyFCA@mail.gmail.com>
References: <BANLkTin8mE=DLWma=U+CdJaQW03X2M2W1w@mail.gmail.com>
	<20110426055521.GA18473@localhost>
	<BANLkTik8k9A8N8CPk+eXo9c_syxJFRyFCA@mail.gmail.com>
Date: Tue, 26 Apr 2011 14:07:17 +0800
Message-ID: <BANLkTim0MNgqeh1KTfvpVFuAvebKyQV8Hg@mail.gmail.com>
Subject: Re: readahead and oom
From: Dave Young <hidave.darkstar@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 2:05 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Tue, Apr 26, 2011 at 1:55 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> On Tue, Apr 26, 2011 at 01:49:25PM +0800, Dave Young wrote:
>>> Hi,
>>>
>>> When memory pressure is high, readahead could cause oom killing.
>>> IMHO we should stop readaheading under such circumstances。If it's true
>>> how to fix it?
>>
>> Good question. Before OOM there will be readahead thrashings, which
>> can be addressed by this patch:
>>
>> http://lkml.org/lkml/2010/2/2/229
>
> Hi, I'm not clear about the patch, could be regard as below cases?
> 1) readahead alloc fail due to low memory such as other large allocation

For example vm balloon allocate lots of memory, then readahead could
fail immediately and then oom

> 2) readahead thrashing caused by itself
>
>>
>> However there seems no much interest on that feature.. I can separate
>> that out and resubmit it standalone if necessary.
>>
>> Thanks,
>> Fengguang
>>
>
>
>
> --
> Regards
> dave
>



-- 
Regards
dave
