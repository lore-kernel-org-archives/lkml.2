Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1BMW2A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 17:28:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53177 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab1BMW1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 17:27:53 -0500
Message-ID: <4D585AC0.3060000@zytor.com>
Date: Sun, 13 Feb 2011 14:27:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: x32-abi@googlegroups.com
CC: "H.J. Lu" <hjl.tools@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: X32 psABI status
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>	<201102132110.29630.arnd@arndb.de> <AANLkTimZA1Npf0nJ8PF-2=8Oe2LXr_ShyBJNkf8Dn5S5@mail.gmail.com> <4D584A49.80306@zytor.com>
In-Reply-To: <4D584A49.80306@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2011 01:16 PM, H. Peter Anvin wrote:
> 
> The actual idea is to use the i386 compat ABI for memory layout, but
> with a 64-bit register convention.  That means that system calls that
> don't make references to memory structures can simply use the 64-bit
> system calls, otherwise we're planning to reuse the i386 compat system
> calls, but invoke them via the syscall instruction (which requires a new
> system call table) and to pass 64-bit arguments in single registers.
> 

Oh, and as to why not copy the i386 system call list straight off... we
don't really want to add a new ABI with crap like sys_socketcall.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

