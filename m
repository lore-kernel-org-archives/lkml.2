Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab1E3Cu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 22:50:57 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:49505 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1E3Cu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 22:50:56 -0400
Date: Sun, 29 May 2011 22:50:52 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the idle-test tree with the  tree
In-reply-to: <20110530122531.53399126.sfr@canb.auug.org.au>
Message-id: <alpine.LFD.2.02.1105292247420.10035@arrandale.kernel.org>
References: <20110530122531.53399126.sfr@canb.auug.org.au>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Today's linux-next merge of the idle-test tree got a conflict in
> arch/x86/include/asm/processor.h, arch/x86/kernel/cpu/common.c and
> arch/x86/kernel/process.c between commits from Linus' tree and similar
> commits from the idle-test tree.
> 
> I used the versions from Linus' tree as they seem to have been committed
> more recently (this may not be the correct solution).

I'll refresh the offending patch in idle-test -- upstream
changed out from under it.

thanks,
-Len
