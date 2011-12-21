Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab1LUBIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:08:09 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37702 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab1LUBIH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:08:07 -0500
MIME-Version: 1.0
In-Reply-To: <4EF12D58.4000105@fb.com>
References: <cover.1323739287.git.luto@amacapital.net> <4EF12D58.4000105@fb.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 20 Dec 2011 17:07:45 -0800
Message-ID: <CALCETrXeXqYhU11OLECF-Kp+F1w34NFvvn2X2fuvsf+pciiLTw@mail.gmail.com>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        john stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 4:50 PM, Arun Sharma <asharma@fb.com> wrote:
> On 12/12/11 5:26 PM, Andy Lutomirski wrote:
>>
>> On x86-64, clock_gettime is so fast that the overhead converting to and
>> from nanoseconds is non-negligible.  clock_gettime_ns is a different
>> interface that is potentially faster.  If people like the ABI, I'll
>> implement an optimized version.
>
>
> Didn't see any major objections to this proposal.
>
> Andy: will you be posting an optimized version?

Yes, probably in a day or two.  It's mostly written, but I want to
generate some benchmarks to go with it.

--Andy
