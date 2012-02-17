Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab2BQSev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:34:51 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:46840 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752218Ab2BQSeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:34:50 -0500
Message-ID: <4F3E9DC8.6090304@xenotime.net>
Date: Fri, 17 Feb 2012 10:34:48 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: linux-next: Tree for Feb 17 (uml)
References: <20120217165045.2394d944d6efc37104421d2e@canb.auug.org.au>
In-Reply-To: <20120217165045.2394d944d6efc37104421d2e@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 09:50 PM, Stephen Rothwell wrote:
> Hi all,
>
> Changes since 20120216:


uml on x86_64 (defconfig):

   CC      arch/um/kernel/asm-offsets.s
In file included from linux-next-20120217/include/linux/slab.h:12:0,
                  from linux-next-20120217/include/linux/crypto.h:23,
                  from 
linux-next-20120217/arch/x86/um/shared/sysdep/kernel-offsets.h:4,
                  from linux-next-20120217/arch/um/kernel/asm-offsets.c:1:
linux-next-20120217/include/linux/gfp.h: In function 'gfp_zonelist':
linux-next-20120217/include/linux/gfp.h:267:1: error: 
'__enabled_CONFIG_NUMA' undeclared (first use in this function)
linux-next-20120217/include/linux/gfp.h:267:1: note: each undeclared 
identifier is reported only once for each function it appears in
linux-next-20120217/include/linux/gfp.h:267:1: error: 
'__enabled_CONFIG_NUMA_MODULE' undeclared (first use in this function)



-- 
~Randy
