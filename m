Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1GOXH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 19:07:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33882 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab1GOXH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 19:07:27 -0400
Message-ID: <4E20C80A.4050307@zytor.com>
Date: Fri, 15 Jul 2011 16:06:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: [PATCH RFC 0/7] x86: convert ticketlocks to C and remove duplicate
 code
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com> <4E0506A8.3010102@zytor.com> <4E0512BC.5010900@goop.org> <1ade2577-044b-4391-a607-91a4a989c3ff@email.android.com> <4E2077E1.4060606@goop.org>
In-Reply-To: <4E2077E1.4060606@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2011 10:24 AM, Jeremy Fitzhardinge wrote:
> 
> I posted a bug about gcc not generating cmp %ah, %al in this case, but the general consensus was that
> it's not a good choice on current Intel chips, because it causes a partial word stall, and that the
> current generated code is better.  (And gcc can generate "cmp %Xh, %Xl" if it wants to - see below.)
> 

Which version of gcc is this, and also, do you have the gcc bug report
number?  I was talking to H.J. and he said he thought it sounded strange.

	-hpa
