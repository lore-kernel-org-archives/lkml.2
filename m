Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab0FIRiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 13:38:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18195 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab0FIRiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 13:38:03 -0400
Date: Wed, 9 Jun 2010 10:36:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       davem@davemloft.net
Subject: Re: linux-next: Tree for June 9 (niu)
Message-Id: <20100609103657.66252a27.randy.dunlap@oracle.com>
In-Reply-To: <20100609133443.38f1f957.sfr@canb.auug.org.au>
References: <20100609133443.38f1f957.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090204.4C0FD171.01E1:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jun 2010 13:34:43 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100608:
> 
> My fixes tree contains:
>       v4l-dvb: update gfp/slab.h includes
>       arm: update gfp/slab.h includes
>       davinci: update gfp/slab.h includes
>       ocfs2: update gfp/slab.h includes
>       acpi: update gfp/slab.h includes



on x86_64 or i386, CONFIG_OF_DEVICE is not enabled:

drivers/net/niu.c:9700: warning: 'struct of_device' declared inside parameter list
drivers/net/niu.c:9700: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/net/niu.c:9716: warning: assignment from incompatible pointer type

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
