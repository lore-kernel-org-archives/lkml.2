Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab1GVSdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 14:33:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33754 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab1GVSdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 14:33:00 -0400
Message-ID: <4E29C241.70102@zytor.com>
Date: Fri, 22 Jul 2011 11:32:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 3/8] x86/ticketlock: Use C for __ticket_spin_unlock
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com> <aa0d82c6e7a1c22a941da0df3c4ba58fea375074.1308878118.git.jeremy.fitzhardinge@citrix.com> <4E050704.3070409@zytor.com> <4E05128D.4020000@goop.org>
In-Reply-To: <4E05128D.4020000@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2011 03:41 PM, Jeremy Fitzhardinge wrote:
> On 06/24/2011 02:52 PM, H. Peter Anvin wrote:
>> These should be asm volatile, I believe.
> 
> OK.
> 
>     J

You still owe me a new patch here, I believe...

	-hpa

