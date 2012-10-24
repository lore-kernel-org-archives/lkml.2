Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965215Ab2JXBDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 21:03:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49442 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666Ab2JXBDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 21:03:11 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1210232307480.2756@ionos>
References: <20121016223508.GR2616@ZenIV.linux.org.uk> <201210192041.q9JKf7jD003998@farm-0010.internal.tilera.com>
 <20121019213548.GR2616@ZenIV.linux.org.uk> <5082A1F1.3080303@tilera.com>
 <20121020153401.GT2616@ZenIV.linux.org.uk> <20121020171643.GU2616@ZenIV.linux.org.uk>
 <5086D432.4070008@tilera.com> <20121023184122.GZ2616@ZenIV.linux.org.uk>
 <alpine.LFD.2.02.1210232232070.2756@ionos> <20121023205119.GA27729@sigill.intra.peff.net>
 <alpine.LFD.2.02.1210232307480.2756@ionos>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Oct 2012 04:02:49 +0300
X-Google-Sender-Auth: DGiBmrZyZJcepPIhd-017quol1Q
Message-ID: <CA+55aFyYD2jvD3+TSe=GhBgg5UQt2RNFdYf6HGiKRX-xWzFmdw@mail.gmail.com>
Subject: Re: [PATCH] tile: support GENERIC_KERNEL_THREAD and GENERIC_KERNEL_EXECVE
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff King <peff@peff.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>, git@vger.kernel.org,
        Junio C Hamano <gitster@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 12:25 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> It is spelled:
>>
>>   git notes add -m <comment> SHA1
>
> Cool!

Don't use them for anything global.

Use them for local codeflow, but don't expect them to be distributed.
It's a separate "flow", and while it *can* be distributed, it's not
going to be for the kernel, for example. So no, don't start using this
to ack things, because the acks *will* get lost.

             Linus
