Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab2LKWrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:47:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab2LKWrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:47:03 -0500
Date: Tue, 11 Dec 2012 19:55:39 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Gleb Natapov <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [PATCH] [RESEND] x86/kexec: crash_vmclear_local_vmcss needs __rcu
Message-ID: <20121211215539.GA4468@amt.cnet>
References: <50C18168.305@cn.fujitsu.com>
 <50C6F8C6.9000008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C6F8C6.9000008@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 05:11:34PM +0800, Zhang Yanfei wrote:
> This removes the sparse warning:
> arch/x86/kernel/crash.c:49:32: sparse: incompatible types in comparison expression (different address spaces)
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kexec.h |    3 ++-
>  arch/x86/kernel/crash.c      |    4 ++--
>  2 files changed, 4 insertions(+), 3 deletions(-)

Applied, thanks.

