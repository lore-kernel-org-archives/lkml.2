Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345Ab2K3Qky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:40:54 -0500
Received: from service87.mimecast.com ([91.220.42.44]:54804 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472Ab2K3Qkx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:40:53 -0500
Date: Fri, 30 Nov 2012 16:40:48 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Kyle McMartin <kyle@mcmartin.ca>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tony Luck <tony.luck@intel.com>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH] perf tools: fix build for various architectures
Message-ID: <20121130164047.GD14454@e106331-lin.cambridge.arm.com>
References: <1354018591-26656-1-git-send-email-mark.rutland@arm.com>
 <20121127134116.GC18340@ghostprotocols.net>
MIME-Version: 1.0
In-Reply-To: <20121127134116.GC18340@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 30 Nov 2012 16:40:49.0128 (UTC) FILETIME=[7405C680:01CDCF19]
X-MC-Unique: 112113016405107201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 01:41:16PM +0000, Arnaldo Carvalho de Melo wrote:
> Em Tue, Nov 27, 2012 at 12:16:31PM +0000, Mark Rutland escreveu:
> > The UAPI changes broke the perf tool, and as of 3.7-rc7, it
> > still won't build for arm:
> > 
> > 	util/../../../arch/arm/include/asm/unistd.h:16:29: fatal error: uapi/asm/unistd.h: No such file or directory
> > 	compilation terminated.
>  
> > I've tested this on arm, but I don't have the necessary toolchains to
> > check the other cases.
> 
> Can you try with my perf/urgent branch?
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/urgent

It builds and runs fine for me on my A9x4 coretile.

> I tested it with raspbian on a raspberry pi system and also with a cross
> compiler on a x86_64 workstation.
> 
> I already sent the pull request to Ingo, that should process it and push
> to Linus soon.

Let's hope it gets merged before v3.7 is tagged.

Thanks,
Mark

