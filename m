Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2GAJol (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 05:44:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428Ab2GAJoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 05:44:19 -0400
Date: Sun, 1 Jul 2012 12:44:30 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: Tree for June 29 (kvm)
Message-ID: <20120701094430.GB4642@redhat.com>
References: <20120629175341.22a9eccd30d9c085bfd92c1d@canb.auug.org.au>
 <4FEDEE6A.7020608@xenotime.net>
 <4FF01B59.1010600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF01B59.1010600@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 12:41:45PM +0300, Avi Kivity wrote:
> On 06/29/2012 09:05 PM, Randy Dunlap wrote:
> > On 06/29/2012 12:53 AM, Stephen Rothwell wrote:
> > 
> >> Hi all,
> >> 
> >> Changes since 20120628:
> > 
> > 
> > 
> > on i386:
> > 
> > arch/x86/built-in.o: In function `kvm_guest_apic_eoi_write':
> > kvm.c:(.text+0x3561f): undefined reference to `apic'
> > 
> > 
> > Full randconfig file is attached.
> 
> Michael, please disable pveoi if built with no apic.

Will do.
How do I tweak config to test this? Any hints?

> 
> -- 
> error compiling committee.c: too many arguments to function
> 
