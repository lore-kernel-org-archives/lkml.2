Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab2B1Ffu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 00:35:50 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37393 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab2B1Fft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 00:35:49 -0500
Date: Tue, 28 Feb 2012 11:04:42 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Keniston <jkenisto@us.ibm.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: linux-next: manual merge of the uprobes tree with Linus' tree
Message-ID: <20120228053442.GB32211@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120228134319.033a60df8db2925d91604c18@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120228134319.033a60df8db2925d91604c18@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022805-9360-0000-0000-0000040A0FF7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> Today's linux-next merge of the uprobes tree got a conflict in
> kernel/fork.c between commit d80e731ecab4 ("epoll: introduce POLLFREE to
> flush ->signalfd_wqh before kfree()") from Linus' tree and commit
> 1f9eb65410a6 ("uprobes/core: handle breakpoint and signal step
> exception") from the uprobes tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Okay, Thanks for letting me know. 

I will fix this up accordingly.

