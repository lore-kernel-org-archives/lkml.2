Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab1BMXDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 18:03:51 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50484 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab1BMXDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 18:03:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oVFOgTKW033Pz9ghGH4NQOabLXoBV9bOSgB+xzYmak5JVGjDoGNxgaCqN/BAyKXRW3
         LW2sy/Lf6hxDOM2kRz5s2kYk2Z2HstrtEM2Ss20ZtDZEJE3A5gnejRLh1+On5vhGVpOb
         xnTSZv86apU0cIPRxARunzYSkr90LVUQ6cCRg=
MIME-Version: 1.0
In-Reply-To: <201102132357.29725.arnd@arndb.de>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
	<201102132328.15360.arnd@arndb.de>
	<4D585F5F.6030708@zytor.com>
	<201102132357.29725.arnd@arndb.de>
Date: Sun, 13 Feb 2011 15:03:47 -0800
Message-ID: <AANLkTimH6gYhcDit3E0TMY=i=DT2s1_difMuvr3vkVzk@mail.gmail.com>
Subject: Re: X32 psABI status
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x32-abi@googlegroups.com,
        GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 2:57 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
>> The cost of an entire different ABI layer (supporting a new memory layout)
>> would be enormous, a.k.a. "not worth it", which is why the memory layout
>> of kernel objects needs to be compatible with i386.
>
> Right, this makes sense, you certainly can't redefine all the data
> structures.
>
> What would probably be a good idea is to compare the set of syscalls
> in X32 and asm-generic, and to either eliminate or document the
> differences. You can probably even take the asm-generic syscall numbers,
> even if you keep the i386 data structures.
>

x32 system call number is BASE + 64bit system call number.  It is
easy to keep 64bit and x32 in sync.

-- 
H.J.
