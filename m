Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab1AaVqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:46:54 -0500
Received: from claw.goop.org ([74.207.240.146]:40191 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756447Ab1AaVqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:46:53 -0500
Message-ID: <4D472DCA.8080402@goop.org>
Date: Mon, 31 Jan 2011 13:46:50 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Nick Piggin <npiggin@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/6] Clean up ticketlock implementation
References: <cover.1295909908.git.jeremy.fitzhardinge@citrix.com> <AANLkTikPfjzpQn4nYgoAyAJ6sDnZM-a0b3V794Q_Mpy+@mail.gmail.com>
In-Reply-To: <AANLkTikPfjzpQn4nYgoAyAJ6sDnZM-a0b3V794Q_Mpy+@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2011 05:08 PM, Nick Piggin wrote:
>> So very similar, except the compiler misses directly comparing
>> %ah to %al.
> Oh :(
>
> Have you filed a bug with gcc?

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=47556

    J

