Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab1HBRCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 13:02:06 -0400
Received: from claw.goop.org ([74.207.240.146]:35252 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627Ab1HBRCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 13:02:01 -0400
Message-ID: <4E382D88.4020302@goop.org>
Date: Tue, 02 Aug 2011 10:02:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86/spinlocks optional for 3.1
References: <201108011753.p71HrrTr011226@hera.kernel.org> <CA+55aFyKFP3KzVfSEO02TjjmMDDL5agCJjKERFdmStM4k9DtQQ@mail.gmail.com> <4E374C9E.5000102@zytor.com>
In-Reply-To: <4E374C9E.5000102@zytor.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2011 06:02 PM, H. Peter Anvin wrote:
> On 08/01/2011 05:04 PM, Linus Torvalds wrote:
>> If that xadd implementation could perhaps be shared, I wouldn't hate
>> it so much. As it is, I really don't see the point in pulling this.
>>
> OK, no problem.  We'll rework it for 3.2.
>

Agreed.  The xadd helper is actually identical between the two, aside
from the 64-bit form.  I was following the form of cmpchg_32/64.h, but
to be honest I don't understand why they're separate.  Is it some
remaining TBD unification?

    J
