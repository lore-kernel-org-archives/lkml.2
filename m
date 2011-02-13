Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab1BMUKy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 15:10:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab1BMUKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 15:10:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: X32 psABI status
Date: Sun, 13 Feb 2011 21:10:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com,
        "H. Peter Anvin" <hpa@linux.intel.com>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
In-Reply-To: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201102132110.29630.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:5ibGvVBCgpch2A3vhnqRipXn64Bg/40bU/GsupBFgOL
 9YadLVt+S2q77tf3/GxsKtd1cGPlTDG9uYyr3eljHEPoPKKiJK
 J2KMzKCI3Kg9R+CW+15gO/0kclqS4wogOhSK+iXXrPFg6znO/R
 yMSWWiw7CyM3IKDayLRHW03dSMMRh1m6K5OEf3c2XqZKMzOb/U
 tebmWwvuzPop4EltAvfPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 February 2011 20:41:01 H.J. Lu wrote:
> Hi,
> 
> We made lots of progresses on x32 pABI:
> 
> https://sites.google.com/site/x32abi/
> 
> 1. Kernel interface with syscall is close to be finalized.

Really? I haven't seen this being posted for review yet ;-)

The basic concept looks entirely reasonable to me, but I'm
curious what drove the decision to start out with the x86_64
system calls instead of the generic ones.

Since tile was merged, we now have support for compat syscalls
in the generic syscall ABI. I would have assumed that it
was possible to just use those if you decide to do a new
ABI in the first place.

The other option that would have appeared natural to me is
to just use the existing 32 bit compat ABI with the few
necessary changes done based on the personality.

	Arnd
