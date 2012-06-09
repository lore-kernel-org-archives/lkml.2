Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab2FIGcn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 02:32:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37306 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab2FIGcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 02:32:42 -0400
Message-ID: <4FD2EDFD.1060508@zytor.com>
Date: Fri, 08 Jun 2012 23:32:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3 v2] [GIT PULL][3.6] x86: cr2 and cmpxchg issues of
 NMI
References: <20120609020257.248773533@goodmis.org> <1339210729.13377.68.camel@gandalf.stny.rr.com>
In-Reply-To: <1339210729.13377.68.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2012 07:58 PM, Steven Rostedt wrote:
> On Fri, 2012-06-08 at 22:02 -0400, Steven Rostedt wrote:
>> Ingo,
>>
>> This is the version 2 with the updates suggested by H. Peter Anvin.
>>
>> Please pull the latest tip/x86/core-2 tree, which can be found at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
>> tip/x86/core-2
>>
> 
> FYI, I based this off of tip/x86/debug.
> 

Hm... actually it looks more like you reused an old branch and forgot to
actually push it out.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

