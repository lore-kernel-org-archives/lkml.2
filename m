Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab2KJBWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:22:05 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:24118 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab2KJBWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:22:01 -0500
Message-ID: <1352510516.7611.1.camel@lorien2>
Subject: Re: [PATCH RFT RESEND linux-next] sparc: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: David Miller <davem@davemloft.net>, Joerg Roedel <joro@8bytes.org>
Cc: kyungmin.park@samsung.com, arnd@arndb.de, m.szyprowski@samsung.com,
        sam@ravnborg.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Date: Fri, 09 Nov 2012 18:21:56 -0700
In-Reply-To: <20121109.195417.1781257873335425911.davem@davemloft.net>
References: <1351267989.4013.20.camel@lorien2>
	 <20121109.193849.458704479891559672.davem@davemloft.net>
	 <1352508743.5524.41.camel@lorien2>
	 <20121109.195417.1781257873335425911.davem@davemloft.net>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-09 at 19:54 -0500, David Miller wrote:
> From: Shuah Khan <shuah.khan@hp.com>
> Date: Fri, 09 Nov 2012 17:52:23 -0700
> 
> > On Fri, 2012-11-09 at 19:38 -0500, David Miller wrote:
> >> From: Shuah Khan <shuah.khan@hp.com>
> >> Date: Fri, 26 Oct 2012 10:13:09 -0600
> >> 
> >> > Add support for debug_dma_mapping_error() call to avoid warning from
> >> > debug_dma_unmap() interface when it checks for mapping error checked
> >> > status. Without this patch, device driver failed to check map error
> >> > warning is generated.
> >> > 
> >> > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> >> 
> >> This doesn't even compile:
> >> 
> >> /home/davem/src/GIT/sparc/arch/sparc/include/asm/dma-mapping.h: In function 'dma_mapping_error':
> >> /home/davem/src/GIT/sparc/arch/sparc/include/asm/dma-mapping.h:62:2: error: implicit declaration of function 'debug_dma
> >> _mapping_error' [-Werror=implicit-function-declaration]
> >> cc1: some warnings being treated as errors
> >> In file included from include/linux/dma-mapping.h:76:0,
> >>                  from include/linux/skbuff.h:33,
> >>                  from include/linux/icmpv6.h:4,
> >>                  from include/linux/ipv6.h:58,
> >>                  from include/net/ipv6.h:16,
> >>                  from include/linux/sunrpc/clnt.h:26,
> >>                  from include/linux/nfs_fs.h:30,
> >>                  from init/do_mounts.c:30:
> > 
> > The problem the dependent patch is in linux-next and not in arch trees
> > yet. That is why I am trying it get this through linux-next and/or
> > dma-debug tree. I am open to suggestions on what is the best route.
> 
> Then please put this in via the dma-debug tree:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks
-- Shuah


