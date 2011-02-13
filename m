Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab1BMXfC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 18:35:02 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50866 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754570Ab1BMXe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 18:34:56 -0500
Date: Sun, 13 Feb 2011 23:39:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>, x32-abi@googlegroups.com,
        "H.J. Lu" <hjl.tools@gmail.com>, GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: X32 psABI status
Message-ID: <20110213233926.1b3ca15a@lxorguk.ukuu.org.uk>
In-Reply-To: <4D585F5F.6030708@zytor.com>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
	<AANLkTimZA1Npf0nJ8PF-2=8Oe2LXr_ShyBJNkf8Dn5S5@mail.gmail.com>
	<4D584A49.80306@zytor.com>
	<201102132328.15360.arnd@arndb.de>
	<4D585F5F.6030708@zytor.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> a. the int $0x80 instruction is much slower than syscall.  An actual
>    i386 process can use the syscall instruction which is disambiguated
>    by the CPU based on mode, but an x32 process is in the same CPU mode
>    as a normal 64-bit process.

So set a flag, whoopee

> b. 64-bit arguments have to be split between two registers for the
>    i386 entry points, requiring user-space stubs.

Diddums. Given you've yet to explain why everyone desperately needs this
extra interface why do we care ?

> All in all, the cost of an extra system call table is quite modest.

And the cost of not doing it is a gloriously wonderful zero. Yo've still
not explained the justification or what large number of apps are going to
use it.

It's a simple question - why do we care, why do we want the overhead and
the hassle, what do users get in return ?

Alan
