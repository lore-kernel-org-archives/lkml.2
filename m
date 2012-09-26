Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab2IZHHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:07:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51660 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2IZHHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:07:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120926052309.GD27339@linux.vnet.ibm.com>
References: <CANFS6bZtOPe8XbsgC0V0encVLssFShWGhNLZQkCvEhKcNT946w@mail.gmail.com>
	<5062938F.2080703@hitachi.com>
	<20120926052309.GD27339@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2012 16:07:34 +0900
Message-ID: <CANFS6bbRz-PtZjDrv2qvk1=8uCQZxtO6OzK+sRO2nS0GSzH1VA@mail.gmail.com>
Subject: Re: [QUESTION] Can uprobe_event support @ADDR, $retval, offs(FETCHARG)?
From: Hyeoncheol Lee <hyc.lee@gmail.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/26 Srikar Dronamraju <srikar@linux.vnet.ibm.com>:
>>
>> Perhaps, it is not so small things, but at least, we can try.
>> In the userspace, memories(pages) can be paged out on swap or
>> files. In that case, memory dereference function needs to track
>> down the data on the disk and it causes I/O. This means we will
>> see the visible performance degradation with tracing.
>> And also, sometime a pointer value (address) is broken, in that
>> case we have to ensure the address is actually valid before
>> accessing it.
>>
>> Of cause, without tracking paged-out data, it is easy
>> to support, because that is already done in kprobe event.
>> I'm not sure how it is useful, because sometimes it will
>> fail to access gather the data.
>> However it is good for the first step, I think.
>>
>> Srikar, what would you think?
>
> I think we should do the best effort basis first. i.e support for
> tracking data thats not paged out.
> Most times the data that is requested tends to the hot data.
>
> We could look at supporting data that is paged out later.
>
>>
>> BTW, if we can support offs(FETCHARGS), $stack and $stackN
>> are also available. ;)
>>
>
> --
> Thanks and Regards
> Srikar Dronamraju
>

I asked this question. because I need Perf that supports to access
user process's variables. and I am trying to add this feature.

Thank you for your answer.

Hyeoncheol
