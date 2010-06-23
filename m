Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab0FWKPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:15:23 -0400
Received: from verein.lst.de ([213.95.11.210]:56361 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab0FWKPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:15:20 -0400
Date: Wed, 23 Jun 2010 12:14:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, x86@kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Greg Ungerer <gerg@uclinux.org>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/40] x86, compat: convert ia32 layer to use
Message-ID: <20100623101402.GA10564@lst.de>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com> <1277287401-28571-13-git-send-email-imunsie@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277287401-28571-13-git-send-email-imunsie@au1.ibm.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44,UPPERCASE_25_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any reason we need to differenciate between COMPAT_SYSCALL_DEFINE and
ARCH_COMPAT_SYSCALL_DEFINE?  We don't need this for native system calls,
so I can't see the reason to do it for compat system calls.

