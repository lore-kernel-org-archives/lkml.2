Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab2C0KTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 06:19:20 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39946 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757992Ab2C0KTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 06:19:18 -0400
Date: Tue, 27 Mar 2012 13:19:09 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Randy Dunlap <rdunlap@xenotime.net>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, mingo@elte.hu
Subject: Re: linux-next: Tree for Feb 2 (kvmtool)
In-Reply-To: <4F2B1C1B.1040700@xenotime.net>
Message-ID: <alpine.LFD.2.02.1203271318470.19093@tux.localdomain>
References: <20120202144516.11b33e667a7cbb8d85d96226@canb.auug.org.au> <4F2B1C1B.1040700@xenotime.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Feb 2012, Randy Dunlap wrote:
> On 02/01/2012 07:45 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20120201:
> 
> 
> On some randconfig i386 builds, I am seeing this:
> 
> warning: (KVMTOOL_TEST_ENABLE && AMD_IOMMU) selects PCI_MSI which has unmet direct dependencies (PCI && ARCH_SUPPORTS_MSI)
> 
> because ARCH_SUPPORTS_MSI needs both X86_LOCAL_APIC and X86_IO_APIC
> but configs don't necessarily have both of them enabled.
> 
> Do you want to add more selects here?
> (this mess could continue for quite some time with other kconfig symbols)

Ping? Sasha, Ingo, thoughts?

				Pekka
