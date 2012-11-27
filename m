Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab2K3QRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:17:35 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:39623 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2K3QRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:17:34 -0500
Date: Tue, 27 Nov 2012 10:41:16 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Kyle McMartin <kyle@mcmartin.ca>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tony Luck <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] perf tools: fix build for various architectures
Message-ID: <20121127134116.GC18340@ghostprotocols.net>
References: <1354018591-26656-1-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354018591-26656-1-git-send-email-mark.rutland@arm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 27, 2012 at 12:16:31PM +0000, Mark Rutland escreveu:
> The UAPI changes broke the perf tool, and as of 3.7-rc7, it
> still won't build for arm:
> 
> 	util/../../../arch/arm/include/asm/unistd.h:16:29: fatal error: uapi/asm/unistd.h: No such file or directory
> 	compilation terminated.
 
> I've tested this on arm, but I don't have the necessary toolchains to
> check the other cases.

Can you try with my perf/urgent branch?

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/urgent

I tested it with raspbian on a raspberry pi system and also with a cross
compiler on a x86_64 workstation.

I already sent the pull request to Ingo, that should process it and push
to Linus soon.

- Arnaldo
