Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0JNAiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:38:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699Ab0JNAit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:38:49 -0400
Date: Wed, 13 Oct 2010 17:38:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Feng Tang <feng.tang@intel.com>
Subject: Re: linux-next: Tree for October 13
Message-Id: <20101013173826.f4b911b4.akpm@linux-foundation.org>
In-Reply-To: <20101013154522.7b087a20.sfr@canb.auug.org.au>
References: <20101013154522.7b087a20.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010 15:45:22 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

In an i386 allmodconfig build, compilation of
arch/x86/kernel/early_printk_mrst.c is emitting a call to
__this_fixmap_does_not_exist().  
