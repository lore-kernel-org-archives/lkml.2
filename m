Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab2BTRI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:08:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35229 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab2BTRIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:08:25 -0500
References: <1329617173.1561.5.camel@acer.local.home> <20120219125601.GD25900@elte.hu> <1329663451.25686.21.camel@gandalf.stny.rr.com> <20120220081045.GD30810@elte.hu> <1329748907.25686.29.camel@gandalf.stny.rr.com> <20120220153452.GA4962@elte.hu>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120220153452.GA4962@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][GIT PULL][v3.3] x86: Test saved %rip in NMI to determine nested NMI
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 20 Feb 2012 09:07:47 -0800
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <035b3b78-4af7-42e8-9694-d7f6c9f2e59e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not even all that legacy.

Ingo Molnar <mingo@elte.hu> wrote:

>
>* Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> On Mon, 2012-02-20 at 09:10 +0100, Ingo Molnar wrote:
>> > > 
>> > > Note, it does not seem to cause any destruction, but screw up 
>> > > profiling.
>> > 
>> > Except if the source of the NMI was not profiling, right?
>> 
>> Well, what else are NMIs used for? [...]
>
>There's various (legacy) diagnostics NMIs on various x86 
>platforms, mostly signalling some sort of deep trouble
>with the hw.
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
