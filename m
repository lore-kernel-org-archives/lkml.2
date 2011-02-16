Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442Ab1BPIzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:55:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43255 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1BPIzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:55:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sNmPowv09RspIP4bXC+sIibf5bff8wc5z844UovHNTXiQG29Zqj1Si94c+cQJB+Vp0
         PjFecPHPrT+9S9aaJ9bwi3Ah4Yt8U7zQ+9PXgiRd3nmJ+uMa/uxpy0a221Jq4dCySSUp
         98MRkR6K0RYcZc85Nw31kwRlApBT9GHtdsbPU=
Message-ID: <4D5B90E8.6080605@gmail.com>
Date: Wed, 16 Feb 2011 09:55:04 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>,
        gregkh@suse.de, srostedt <srostedt@redhat.com>, a.p.zijlstra@chello.nl,
        ghaskins@novell.com, stable@kernel.org, stable-commits@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Patch "sched: Give CPU bound RT tasks preference" has been added
 to the 2.6.32-longterm tree
References: <12978046423644@kroah.org> <1297810967.23343.122.camel@gandalf.stny.rr.com> <1297821667.5126.11.camel@marge.simson.net> <20110216082559.GA16529@elte.hu>
In-Reply-To: <20110216082559.GA16529@elte.hu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2011 09:25 AM, Ingo Molnar wrote:
> 
> * Mike Galbraith <efault@gmx.de> wrote:
> 
>> On Tue, 2011-02-15 at 18:02 -0500, Steven Rostedt wrote:
>>> [ Added LKML ]
>>>
>>> On Tue, 2011-02-15 at 13:17 -0800, gregkh@suse.de wrote:
>>>> This is a note to let you know that I've just added the patch titled
>>>>
>>>>     sched: Give CPU bound RT tasks preference
>>>>
>>>> to the 2.6.32-longterm tree which can be found at:
>>>>     http://www.kernel.org/git/?p=linux/kernel/git/longterm/longterm-queue-2.6.32.git;a=summary
>>>>
>>>> The filename of the patch is:
>>>>      0006-sched-Give-CPU-bound-RT-tasks-preference.patch
>>>> and it can be found in the queue-2.6.32 subdirectory.
>>>>
>>>> If you, or anyone else, feels it should not be added to the 2.6.32 longterm tree,
>>>> please let <stable@kernel.org> know about it.
>>>>
>>>>
>>>
>>> I don't mind this patch being added to the long term tree. But I'm
>>> curious about what is the criteria for adding changes to it? This is a
>>> performance improvement and not a critical bug fix.
>>
>> Yes, I added it for the performance.  .32-stable is enterprise beans and
>> biscuits.  Same reason I added the load balancing fixes, boxen won't
>> explode without them, but load balancing performs better with them.
> 
> We try to concentrate on regression fixes though.

Hi, I cannot fully agree with this. The question is who are "we" here?
If every packager using this stable tree is forced by users/customers to
take it anyway, it's better to have it in stable.

It has several reasons:
* It will have an eye of experts on them. Not that at distro providers
there are no experts, but the authors who are cced here know definitely
the code better.
* Not every packager has to duplicate others work.
* The stable tree changes constantly. Managing hundreds of patches
applied to a stable tree before kernels are being packaged is thus
sometimes a hell. Reducing this number is a good thing(TM).

regards,
-- 
js
