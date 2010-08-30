Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab0H3HuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 03:50:07 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44103 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab0H3HuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 03:50:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TSWJZDLryG9jadkVyj2ZtQazyU213Q+Bv7rpYzuMZrSGrGa5EZ8aMNRl/4TFdBa90q
         7/1dF7/1cy8OUYYBLQqQGP3IlrESFs8Je0aSLZAvF3NflT1L5LZ88SPYIE25Hlk9GSBb
         XBQT5AUrZDr81jB4Xgw7KB4BzDTxCtLUA8No4=
Subject: Re: [PATCH -next] ubi: fix kconfig unmet dependency
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-mtd@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20100812121059.e1d40380.randy.dunlap@oracle.com>
References: <20100812121059.e1d40380.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 10:49:57 +0300
Message-ID: <1283154597.12995.6.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-12 at 12:10 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> warning: (OPTPROBES && KPROBES && HAVE_OPTPROBES && !PREEMPT && DEBUG_KERNEL || MTD_UBI_DEBUG && MTD && SYSFS && MTD_UBI || UBIFS_FS_DEBUG && MISC_FILESYSTEMS && UBIFS_FS || LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT && DEBUG_KERNEL && STACKTRACE_SUPPORT && PROC_FS) selects KALLSYMS_ALL which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:	Artem Bityutskiy <dedekind1@gmail.com>
> Cc:	linux-mtd@lists.infradead.org
> ---
>  drivers/mtd/ubi/Kconfig.debug |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Pushed to the ubi-2.6.git tree, thanks! I'll send it to 2.6.36 soon.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

