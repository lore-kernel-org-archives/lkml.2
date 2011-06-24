Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab1FYCD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 22:03:56 -0400
Received: from claw.goop.org ([74.207.240.146]:56541 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab1FYCDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 22:03:49 -0400
Message-ID: <4E05128D.4020000@goop.org>
Date: Fri, 24 Jun 2011 15:41:17 -0700
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
Subject: Re: [PATCH 3/8] x86/ticketlock: Use C for __ticket_spin_unlock
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com> <aa0d82c6e7a1c22a941da0df3c4ba58fea375074.1308878118.git.jeremy.fitzhardinge@citrix.com> <4E050704.3070409@zytor.com>
In-Reply-To: <4E050704.3070409@zytor.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2011 02:52 PM, H. Peter Anvin wrote:
> These should be asm volatile, I believe.

OK.

    J
