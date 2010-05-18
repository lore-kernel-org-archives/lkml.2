Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab0ERVjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:39:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47540 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab0ERVjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:39:09 -0400
Message-ID: <4BF308E9.4040809@zytor.com>
Date: Tue, 18 May 2010 14:38:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Does anyone care about gcc 3.x support for x86 anymore?
References: <1273135546-29690-2-git-send-email-avi@redhat.com>	 <tip-a3c8acd04376d604370dcb6cd2143c9c14078a50@git.kernel.org>	 <1274213443.2485.3.camel@edumazet-laptop>  <4BF2FF26.9050701@zytor.com> <1274217067.2485.9.camel@edumazet-laptop>
In-Reply-To: <1274217067.2485.9.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
