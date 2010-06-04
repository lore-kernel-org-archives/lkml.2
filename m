Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab0FDQzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 12:55:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38104 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab0FDQzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 12:55:20 -0400
Date: Fri, 4 Jun 2010 09:54:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 4 (kernel/module.c)
Message-Id: <20100604095445.2169b9ed.randy.dunlap@oracle.com>
In-Reply-To: <20100604153006.fa15c770.sfr@canb.auug.org.au>
References: <20100604153006.fa15c770.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090203.4C092FEB.01F4:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010 15:30:06 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100603:
> 
> My fixes tree contains:
>       v4l-dvb: update gfp/slab.h includes
>       arm: update gfp/slab.h includes
>       davinci: update gfp/slab.h includes
>       ocfs2: update gfp/slab.h includes
>       acpi: update gfp/slab.h includes
> 
> The wireless tree gained a conflict against the net tree.
> 
> The rr tree gained a build failure for which I applied a patch.


when CONFIG_SYSFS is not enabled:

kernel/module.c:1526: error: implicit declaration of function 'module_remove_modinfo_attrs'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
