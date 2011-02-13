Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab1BMWDc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 17:03:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35775 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab1BMWD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 17:03:27 -0500
Message-ID: <4D58551C.40105@zytor.com>
Date: Sun, 13 Feb 2011 14:03:08 -0800
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
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>	<201102132110.29630.arnd@arndb.de>	<AANLkTimZA1Npf0nJ8PF-2=8Oe2LXr_ShyBJNkf8Dn5S5@mail.gmail.com>	<4D584A49.80306@zytor.com> <AANLkTikbFM5BjcD1=KsO-tHpHn-01Sxnqp40_GtbifYY@mail.gmail.com>
In-Reply-To: <AANLkTikbFM5BjcD1=KsO-tHpHn-01Sxnqp40_GtbifYY@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2011 01:28 PM, H.J. Lu wrote:
> 
> That is is currently implemented on hjl/x32 branch.
> 
> I also added
> 
> __NR_sigaction
> __NR_sigpending
> __NR_sigprocmask
> __NR_sigsuspend
> 
> to help the Bionic C library.
> 

That seems a little redundant... even on the i386 front we want people
to use the rt_sig* system calls.  As a porting aid I can see it, but we
should avoid deprecated system calls in the final version.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

