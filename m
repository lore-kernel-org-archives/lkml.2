Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1FYCDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 22:03:50 -0400
Received: from claw.goop.org ([74.207.240.146]:56546 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab1FYCDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 22:03:49 -0400
Message-ID: <4E0512BC.5010900@goop.org>
Date: Fri, 24 Jun 2011 15:42:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC 0/7] x86: convert ticketlocks to C and remove duplicate
 code
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com> <4E0506A8.3010102@zytor.com>
In-Reply-To: <4E0506A8.3010102@zytor.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2011 02:50 PM, H. Peter Anvin wrote:
> On 06/23/2011 06:19 PM, Jeremy Fitzhardinge wrote:
>> I've been running with this code in place for several months on 4 core
>> systems without any problems.
>>
>> I couldn't measure a consistent performance difference between the two
>> implemenations; there seemed to be +/- ~1% +/-, which is the level of
>> variation I see from simply recompiling the kernel with slightly
>> different code alignment.
>>
>> Overall, I think the large reduction in code size is a big win.
>>
> Could you give us the delta in *compiled* code size?

Sure.  Do you mean for the individual lock sequences, or for the overall
kernel?

    J
