Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab2BUVL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 16:11:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45876 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab2BUVLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 16:11:53 -0500
Message-ID: <4F44087E.3030701@zytor.com>
Date: Tue, 21 Feb 2012 13:11:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jason Baron <jbaron@redhat.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
References: <cover.1329851692.git.jbaron@redhat.com>  <4F43F9F0.4000605@zytor.com> <1329855719.25686.67.camel@gandalf.stny.rr.com>
In-Reply-To: <1329855719.25686.67.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 12:21 PM, Steven Rostedt wrote:
> On Tue, 2012-02-21 at 12:09 -0800, H. Peter Anvin wrote:
>> On 02/21/2012 12:02 PM, Jason Baron wrote:
>>> Hi,
>>>
>>> Renames 'static_branch()' -> very_unlikely(), hopefully, to be more intuitive
>>> as to what jump labels is about. I'm also introducing 'very_likely()', as
>>> the analogue to very_unlikely(). Patch is against the -tip perf branch.
>>>
>>
>> Erk... I'm not happy about this.  very_unlikely() makes it sound like it
>> operates like unlikely(), which really is not the case.  There is a huge
>> difference in mechanism here as well as usage.
> 
> I agree with Peter.
> 
> What about static_branch_true() and static_branch_false().
> 
> Or remove the "_branch" part and have static_true() and static_false()?
> 

static_true() and static_false() seem good.

	-hpa

