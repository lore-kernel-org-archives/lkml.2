Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954Ab1FVVfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 17:35:53 -0400
Received: from claw.goop.org ([74.207.240.146]:37612 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758574Ab1FVVfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 17:35:52 -0400
Message-ID: <4E026036.1040609@goop.org>
Date: Wed, 22 Jun 2011 14:35:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC 0/7] x86: convert ticketlocks to C and remove duplicate
 code
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com> <1308664868.26237.173.camel@twins> <4E0240AC.9060603@goop.org> <4E024E5B.7090103@zytor.com> <4E0257BC.9050509@goop.org> <4E025983.4060106@zytor.com>
In-Reply-To: <4E025983.4060106@zytor.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 02:07 PM, H. Peter Anvin wrote:
> For x86, we support 3.4, 4.0 and 4.1.2 and above (not sure if 4.0.x
> actually works).  Other architectures have different rules.  At some
> point we'll probably drop anything below 4.1.2, but we apparently can't yet.

Looks like the intrinsics turned up in 4.1.0.

    J
