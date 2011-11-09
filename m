Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab1KIUL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:11:57 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:48789 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1KIULz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:11:55 -0500
Date: Wed, 9 Nov 2011 15:11:36 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: linux-next: Tree for Nov 9 (build errors summary)
Message-ID: <20111109201136.GA5760@phenom.dumpdata.com>
References: <20111109135826.7f8270fb7151cf7939998942@canb.auug.org.au>
 <4EBAD329.1020309@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBAD329.1020309@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4EBADE82.010D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 11:23:21AM -0800, Randy Dunlap wrote:
> On 11/08/2011 06:58 PM, Stephen Rothwell wrote:
> > Hi all,
> 
> 
> 1.  on i386, when CONFIG_SMP is not enabled:
> 
> arch/x86/built-in.o: In function `hpet_setup_msi_irq':
> hpet.c:(.text+0x12114): undefined reference to `arch_setup_hpet_msi'
> hpet.c:(.text+0x12123): undefined reference to `destroy_irq'
> arch/x86/built-in.o: In function `hpet_msi_capability_lookup':
> hpet.c:(.text+0x121fb): undefined reference to `create_irq_nr'
> arch/x86/built-in.o:(.data+0x314): undefined reference to `native_setup_msi_irqs'
> arch/x86/built-in.o:(.data+0x318): undefined reference to `native_teardown_msi_irq'

This looks new. When did it start happening? err, Any idea which patch
might have caused this?
