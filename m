Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934393Ab2FHRjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:39:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60912 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab2FHRjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:39:41 -0400
Message-ID: <4FD238CD.8000601@zytor.com>
Date: Fri, 08 Jun 2012 10:39:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/3] x86: Remove cmpxchg from i386 NMI nesting code
References: <20120608135200.371649691@goodmis.org>   <20120608135603.699156773@goodmis.org> <4FD223E1.1090707@zytor.com>  <1339173716.13377.50.camel@gandalf.stny.rr.com>  <4FD23626.4020802@zytor.com> <1339176975.13377.56.camel@gandalf.stny.rr.com>
In-Reply-To: <1339176975.13377.56.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2012 10:36 AM, Steven Rostedt wrote:
>>
>> On i386 it's infinite, but again, I don't think the code will ever be
>> exercised on i386.  I'm much more concerned about performance on current
>> processors.
> 
> I'm not worried about non i386 here. Some context missing from the patch
> is that this code is surrounded by:
> 

Sorry, I meant i386 as in actual i386 processors, as opposed to modern
processors in 32-bit mode.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

