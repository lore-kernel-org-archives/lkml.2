Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031712Ab2CSPBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:01:04 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:37373 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030969Ab2CSPBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:01:02 -0400
Message-ID: <4F674A2D.5080504@xenotime.net>
Date: Mon, 19 Mar 2012 08:01:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: Re: linux-next: Tree for Mar 19 (uml)
References: <20120319184830.fce597a16eaf7206195a7a45@canb.auug.org.au>
In-Reply-To: <20120319184830.fce597a16eaf7206195a7a45@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 12:48 AM, Stephen Rothwell wrote:

> Hi all,
> 
> News: the build system (see below) has had some more architectures
> enabled.  Thanks to Tony Breeds for his efforts in providing toolchains.
> 
> Changes since 20120315:



on x86_64:

  CC      arch/um/kernel/asm-offsets.s
In file included from include/linux/mm_types.h:16:0,
                 from include/linux/sched.h:64,
                 from arch/x86/um/shared/sysdep/kernel-offsets.h:2,
                 from arch/um/kernel/asm-offsets.c:1:
arch/um/include/asm/mmu.h:15:14: error: array type has incomplete element type
make[2]: *** [arch/um/kernel/asm-offsets.s] Error 1



> -- 

~Randy
