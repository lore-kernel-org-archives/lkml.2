Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab0FWKrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:47:20 -0400
Received: from verein.lst.de ([213.95.11.210]:39520 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab0FWKrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:47:19 -0400
Date: Wed, 23 Jun 2010 12:46:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Ian Munsie <imunsie@au1.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, x86@kernel.org,
       Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Greg Ungerer <gerg@uclinux.org>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/40] x86, compat: convert ia32 layer to use
Message-ID: <20100623104603.GB11845@lst.de>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com> <1277287401-28571-13-git-send-email-imunsie@au1.ibm.com> <20100623101402.GA10564@lst.de> <20100623103619.GC5242@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623103619.GC5242@nowhere>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 12:36:21PM +0200, Frederic Weisbecker wrote:
> I think we wanted that to keep the sys32_ prefixed based naming, to avoid
> collisions with generic compat handler names.

For native syscalls we do this by adding a arch prefix inside the
syscall name, e.g.:

arch/s390/kernel/sys_s390.c:SYSCALL_DEFINE(s390_fallocate)(int fd, int mode, loff_t offset,
arch/sparc/kernel/sys_sparc_64.c:SYSCALL_DEFINE1(sparc_pipe_real, struct pt_regs *, regs)

