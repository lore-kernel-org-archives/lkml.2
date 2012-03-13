Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab2CMSed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:34:33 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39524 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab2CMSeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:34:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6647"; a="169804772"
Date: Tue, 13 Mar 2012 13:34:28 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: David Howells <dhowells@redhat.com>
Cc: paul.gortmaker@windriver.com, hpa@zytor.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        arnd@arndb.de, linux-hexagon@vger.kernel.org
Subject: Re: [PATCH 10/35] Disintegrate asm/system.h for Hexagon [ver #2]
Message-ID: <20120313183428.GC31083@codeaurora.org>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
 <20120312233747.13888.75605.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312233747.13888.75605.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 11:37:47PM +0000, David Howells wrote:
> Disintegrate asm/system.h for Hexagon.  Not compiled.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: linux-hexagon@vger.kernel.org
> ---
> 
>  arch/hexagon/include/asm/atomic.h    |    1 
>  arch/hexagon/include/asm/barrier.h   |   41 +++++++++++
>  arch/hexagon/include/asm/bitops.h    |    1 
>  arch/hexagon/include/asm/cmpxchg.h   |   90 +++++++++++++++++++++++
>  arch/hexagon/include/asm/exec.h      |   28 +++++++
>  arch/hexagon/include/asm/switch_to.h |   34 +++++++++
>  arch/hexagon/include/asm/system.h    |  131 +---------------------------------
>  arch/hexagon/kernel/ptrace.c         |    1 
>  arch/hexagon/kernel/smp.c            |    1 
>  arch/hexagon/kernel/vm_events.c      |    1 
>  10 files changed, 199 insertions(+), 130 deletions(-)
>  create mode 100644 arch/hexagon/include/asm/barrier.h
>  create mode 100644 arch/hexagon/include/asm/cmpxchg.h
>  create mode 100644 arch/hexagon/include/asm/exec.h
>  create mode 100644 arch/hexagon/include/asm/switch_to.h
> 



Acked-by: Richard Kuo <rkuo@codeaurora.org>


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
