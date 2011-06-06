Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab1FFUVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:21:35 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55524 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab1FFUVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:21:33 -0400
Date: Mon, 06 Jun 2011 13:17:18 -0700 (PDT)
Message-Id: <20110606.131718.2215062170051315214.davem@davemloft.net>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, fenghua.yu@intel.com,
        monstr@monstr.eu, ralf@linux-mips.org, benh@kernel.crashing.org,
        paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        linux390@de.ibm.com, lethal@linux-sh.org, jdike@addtoit.com,
        richard@nod.at, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, viro@zeniv.linux.org.uk, oleg@redhat.com,
        akpm@linux-foundation.org, linux-ia64@vger.kernel.org,
        microblaze-uclinux@itee.uq.edu.au, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH -v2] Audit: push audit success and retcode into arch
 ptrace.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110603220451.23134.47368.stgit@paris.rdu.redhat.com>
References: <20110603220451.23134.47368.stgit@paris.rdu.redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 06 Jun 2011 13:17:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>
Date: Fri, 03 Jun 2011 18:04:51 -0400

 ...
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Acked-by: Acked-by: H. Peter Anvin <hpa@zytor.com> [for x86 portion]

For sparc parts:

Acked-by: David S. Miller <davem@davemloft.net>
