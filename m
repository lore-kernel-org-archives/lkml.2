Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab0ITIrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 04:47:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41119 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab0ITIrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 04:47:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Hrwqqu+SE0aB/YkwMB/tS08r5PiyDYCmLcSdN3mAeqApHULJmv4eBl1VINvh+sq6dZ
         D0e8sC5T7n29UDEzNU7xcvCAgi2HBIRW59LK5CIkyuZ24wXgylJYl1CU4NA4y/H6I62V
         E6qBDPR5h2K9EY4mSCTDCfTmcvnw3lLE5QJaE=
Subject: Re: [PATCH] usibfs: fix kconfig dependency warning
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org
In-Reply-To: <20100918125340.7a2cbb8b.randy.dunlap@oracle.com>
References: <20100918125340.7a2cbb8b.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 11:45:28 +0300
Message-ID: <1284972328.2286.49.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-18 at 12:53 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix another kconfig dependency warning, this time in ubifs.
> 
> warning: (MTD_UBI_DEBUG && MTD && SYSFS && MTD_UBI && KALLSYMS && DEBUG_KERNEL || UBIFS_FS_DEBUG && MISC_FILESYSTEMS && UBIFS_FS || LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT && DEBUG_KERNEL && STACKTRACE_SUPPORT && PROC_FS) selects KALLSYMS_ALL which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)

Pushed to the ubifs-2.6.git tree. This won't go to 2.6.36, though, I
think - not too important. But I have anything really important, I'll
merge this one as well, although for now I do not have such plans.

Thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

