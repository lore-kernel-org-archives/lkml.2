Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab1IGXZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 19:25:58 -0400
Received: from claw.goop.org ([74.207.240.146]:53781 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab1IGXZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 19:25:56 -0400
Message-ID: <4E67FD7E.3060300@goop.org>
Date: Wed, 07 Sep 2011 16:25:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC 0/7] x86: convert ticketlocks to C and remove duplicate
 code
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com> <m2pqlw1i70.fsf@firstfloor.org>
In-Reply-To: <m2pqlw1i70.fsf@firstfloor.org>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 01:44 PM, Andi Kleen wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>> I couldn't measure a consistent performance difference between the two
>> implemenations; there seemed to be +/- ~1% +/-, which is the level of
>> variation I see from simply recompiling the kernel with slightly
>> different code alignment.
> I ran your new locks in my lock tester and I have a similar experience.
> There's some variation, but it seems to be in the usual variance.
> In some cases the C locks were actually faster.

Is your test harness available?

    J


