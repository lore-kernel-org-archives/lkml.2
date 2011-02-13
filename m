Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab1BMW22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 17:28:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54662 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab1BMW2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 17:28:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: X32 psABI status
Date: Sun, 13 Feb 2011 23:28:14 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: x32-abi@googlegroups.com, "H.J. Lu" <hjl.tools@gmail.com>,
        GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com> <AANLkTimZA1Npf0nJ8PF-2=8Oe2LXr_ShyBJNkf8Dn5S5@mail.gmail.com> <4D584A49.80306@zytor.com>
In-Reply-To: <4D584A49.80306@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102132328.15360.arnd@arndb.de>
X-Provags-ID: V02:K0:dcfoK1rlClNirn/NgC09772PGiZHPYSGWvUE2z/UIfo
 5DIlSXasdjjLFbVz204pp6L0IDcWJB7vk3GFqtVzVx+yOMs6xk
 kXiTX/YxEv50/AxoSz2uCoBoLAmUJWJkyRJlEz4FIzyXMEjuRj
 YpzME2CAXizkV5swvlP9DkVMwnMUdhSu/bUHOGs7BOu5lkbrt7
 FZ3vlysnCKAKlEMCIBkuQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 February 2011, H. Peter Anvin wrote:
> The actual idea is to use the i386 compat ABI for memory layout, but
> with a 64-bit register convention.  That means that system calls that
> don't make references to memory structures can simply use the 64-bit
> system calls, otherwise we're planning to reuse the i386 compat system
> calls, but invoke them via the syscall instruction (which requires a new
> system call table) and to pass 64-bit arguments in single registers.

As far as I know, any task can already call both the 32 and 64 bit syscall
entry points on x86. Is there anything you can't do just as well by
using a combination of the two methods, without introducing a third one?

	Arnd
