Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab2K2OFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:05:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32191 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab2K2OF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:05:26 -0500
Date: Thu, 29 Nov 2012 09:05:13 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, olaf@aepfle.de
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>
Subject: Re: linux-next: build warning after merge of the xen-two tree
Message-ID: <20121129140513.GA21184@phenom.dumpdata.com>
References: <20121129142530.37630048cd37048f884b17e9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129142530.37630048cd37048f884b17e9@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 02:25:30PM +1100, Stephen Rothwell wrote:
> Hi Konrad,
> 
> After merging the xen-two tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> arch/x86/xen/enlighten.c: In function 'init_hvm_pv_info':
> arch/x86/xen/enlighten.c:1617:16: warning: unused variable 'ebx' [-Wunused-variable]
> arch/x86/xen/enlighten.c:1617:11: warning: unused variable 'eax' [-Wunused-variable]
> 
> Introduced by commit 9d02b43dee0d ("xen PVonHVM: use E820_Reserved area
> for shared_info").

Olaf, could you send me a patch to fix that pls?

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


