Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1BLVLK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 16:11:10 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:49913 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab1BLVLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 16:11:03 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
Subject: Re: X32 psABI status
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
Date: Sat, 12 Feb 2011 22:10:52 +0100
In-Reply-To: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
	(H. J. Lu's message of "Sat, 12 Feb 2011 11:41:01 -0800")
Message-ID: <87aai1gdr7.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. J. Lu:

> We made lots of progresses on x32 pABI:
>
> https://sites.google.com/site/x32abi/
>
> 1. Kernel interface with syscall is close to be finalized.
> 2. GCC x32 branch is stabilizing.
> 3. The Bionic C library works with the syscall kernel interface.
>
> The next major milestone will be x32 glibc port.

It is a bit difficult to extract useful information from these
resources.

Is off_t 32 bits?  Why is the ia32 compatiblity kernel interface used?
I'm sure a lot of people want to get rid of that in cases where they
control the whole software stack.

Is stack alignment to 16 bytes beneficial for X32?
