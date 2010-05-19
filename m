Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0ESBU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:20:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59680 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab0ESBUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:20:25 -0400
Message-ID: <4BF33CAD.2070602@zytor.com>
Date: Tue, 18 May 2010 18:19:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: eric.dumazet@gmail.com, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>
Subject: Does anyone care about gcc 3.x support for *x86* anymore?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Reposting as a separate thread]

Recently, we have seen an increasing number of problems with gcc 3.4 on
x86; mostly due to poor constant propagation producing not just bad code
but failing to properly eliminate what should be dead code.

I'm wondering if there is any remaining real use of gcc 3.4 on x86 for
compiling current kernels (as opposed to residual use for compiling
applications on old enterprise distros.)  I'm specifically not referring
to other architectures here -- most of these issues have been in
relation to low-level arch-specific code, and as such only affects the
x86 architectures.  Other architectures may very well have a much
stronger need for continued support of an older toolchain.

If there isn't a reason to preserve support, I would like to consider
discontinue support for using gcc 3 to compile x86 kernels.  If there is
a valid use case, it would be good to know what it is.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

