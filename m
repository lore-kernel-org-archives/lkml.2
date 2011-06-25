Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1FYDQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 23:16:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52100 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811Ab1FYDQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 23:16:38 -0400
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com> <4E0506A8.3010102@zytor.com> <4E0512BC.5010900@goop.org>
User-Agent: K-9 Mail for Android
In-Reply-To: <4E0512BC.5010900@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RFC 0/7] x86: convert ticketlocks to C and remove duplicate code
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 24 Jun 2011 20:15:42 -0700
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Message-ID: <1ade2577-044b-4391-a607-91a4a989c3ff@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>On 06/24/2011 02:50 PM, H. Peter Anvin wrote:
>> On 06/23/2011 06:19 PM, Jeremy Fitzhardinge wrote:
>>> I've been running with this code in place for several months on 4
>core
>>> systems without any problems.
>>>
>>> I couldn't measure a consistent performance difference between the
>two
>>> implemenations; there seemed to be +/- ~1% +/-, which is the level
>of
>>> variation I see from simply recompiling the kernel with slightly
>>> different code alignment.
>>>
>>> Overall, I think the large reduction in code size is a big win.
>>>
>> Could you give us the delta in *compiled* code size?
>
>Sure.  Do you mean for the individual lock sequences, or for the
>overall
>kernel?
>
>    J

Overall is fine.
-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
