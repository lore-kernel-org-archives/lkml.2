Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab2C1Buc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 21:50:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48125 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab2C1Bub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 21:50:31 -0400
Message-ID: <4F726E56.4070405@zytor.com>
Date: Tue, 27 Mar 2012 18:50:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] Introduce the X32 binary format on x86, for v3.4
References: <20120319175002.GA21093@gmail.com>
In-Reply-To: <20120319175002.GA21093@gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 10:50 AM, Ingo Molnar wrote:
> Linus,
> 
> Please pull the latest x86-x32-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-x32-for-linus
> 
>    HEAD: 31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4 x32: Fix alignment fail in struct compat_siginfo
> 
> This tree introduces the X32 binary format and execution mode 
> for x86: 32-bit data space binaries using 64-bit instructions 
> and 64-bit kernel syscalls.
> 
> This allows applications whose working set fits into a 32 bits 
> address space to make use of 64-bit instructions while using a 
> 32-bit address space with shorter pointers, more compressed data 
> structures, etc.
> 

Hi Linus,

Any problem either with this tree and/or the pull request?  The
posix_types.h revamp ended up being part of this request (because x32
depends on it) but is technically standalone.

	-hpa
