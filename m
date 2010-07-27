Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0G0Sit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 14:38:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25192 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab0G0Sir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 14:38:47 -0400
Message-ID: <4C4F27A3.5040109@oracle.com>
Date: Tue, 27 Jul 2010 11:38:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        jeremy@goop.org, Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: linux-next: Tree for July 27 (xen)
References: <20100727160708.722c39c1.sfr@canb.auug.org.au>
In-Reply-To: <20100727160708.722c39c1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C4F27B0.0256:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20100726:
> 
> 
> The xen tree lost its build problems but gained a conflict against Linus'
> tree.

when X86_32=y, SMP=n, X86_LOCAL_APIC=n:

drivers/built-in.o: In function `xen_callback_vector':
(.text+0x41238): undefined reference to `first_system_vector'

alloc_intr_gate() calls alloc_system_vector(), which uses first_system_vector.
