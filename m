Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab1EQOmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:42:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab1EQOmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:42:18 -0400
Message-ID: <4DD28948.1020900@suse.cz>
Date: Tue, 17 May 2011 16:42:16 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/2] ftrace/kbuild: Add recordmcount files to force
 full build
References: <20110517021027.390391519@goodmis.org>	 <20110517021423.661004726@goodmis.org>	 <20110517133646.GP13293@sepie.suse.cz>	 <1305640042.5456.727.camel@gandalf.stny.rr.com> <1305642010.5456.730.camel@gandalf.stny.rr.com>
In-Reply-To: <1305642010.5456.730.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.5.2011 16:20, Steven Rostedt wrote:
> On Tue, 2011-05-17 at 09:47 -0400, Steven Rostedt wrote:
>> On Tue, 2011-05-17 at 15:36 +0200, Michal Marek wrote:
>>
>>> We could add recordmcount.c as a dependency in scripts/Makefile.build
>>> directly, without playing with fixdep, like this (untested):
>>
>> I actually tried this first, and it didn't seem to work. I'll go ahead
>> and give it another try (maybe I did something wrong). But I do prefer
>> this over my fixdep change.
>>
>> Thanks, I'll let you know the outcome.
>
> Awesome! This worked.

Great.


> I wonder what screw up I did to keep mine from
> working? Anyway, I made a single change to your patch:
>
> -recordmcount_source := $(srctree)/scripts/recordmcount.c
> +recordmcount_source := $(srctree)/scripts/recordmcount.c \
> +                   $(srctree)/scripts/recordmcount.h
>
>
> Could you send me your Signed-off-by, and I'll add this to the beginning
> of my patch queue.

Signed-off-by: Michal Marek <mmarek@suse.cz>

Michal
