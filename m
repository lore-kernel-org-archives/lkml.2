Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1HWQeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:34:37 -0400
Received: from claw.goop.org ([74.207.240.146]:50289 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab1HWQea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:34:30 -0400
Message-ID: <4E53D694.3060802@goop.org>
Date: Tue, 23 Aug 2011 09:34:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 07/15] x86: add xadd helper macro
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com>  <41c1484d36a94613f86f33e15219d5fcd14b2343.1314054734.git.jeremy.fitzhardinge@citrix.com> <1314097172.8002.30.camel@twins>
In-Reply-To: <1314097172.8002.30.camel@twins>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 03:59 AM, Peter Zijlstra wrote:
>
> What you could do is something like:
>
> #define CASE_B	case 1
> #define CASE_W	case 2
> #define CASE_L	case 4
> #ifdef CONFIG_64BIT
> # define CASE_Q	case 8
> #else
> # define CASE_Q case -1 /* sizeof() won't ever return this */
> #endif

Yeah, that's OK, though I'll just make it the constants so there's still
a case keyword in the switch.

    J

