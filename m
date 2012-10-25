Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab2JYL5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:57:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55507 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab2JYL5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:57:01 -0400
Date: Thu, 25 Oct 2012 13:56:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Add support for AMD64 EDAC on multiple PCI domains
Message-ID: <20121025115654.GA27611@gmail.com>
References: <1351153972-14019-1-git-send-email-daniel@numascale-asia.com>
 <20121025110353.GA2623@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025110353.GA2623@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> On Thu, Oct 25, 2012 at 04:32:52PM +0800, Daniel J Blueman wrote:
> > The AMD Northbridge initialisation code and EDAC assume the Northbridge IDs
> > are contiguous, which no longer holds on federated systems with multiple
> > HyperTransport fabrics and multiple PCI domains, eg on Numascale's
> > Numaconnect systems with NumaChip.
> > 
> > Address this assumption by searching the Northbridge ID array, rather than
> > directly indexing it, using the upper bits for the PCI domain.
> > 
> > RFC->v2: Correct array initialisation
> > v2->v3: Add Boris's neater linked list approach
> > 
> > Todo:
> > 1. fix kobject/sysfs oops (see http://quora.org/2012/16-server-boot.txt later)
> > 2. reorder amd64_edac.c or add amd64_per_family_init/pci_get_related_function
> >    forward declarations, based on feedback
> > 
> > Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> 
> This patch contains code from both of us and thus needs both our SOBs:
> 
> Signed-off-by: Borislav Petkov <bp@alien8.de>

No, SOBs are to document patch forwarding. Co-authorship can be 
expressed a number of ways, such as:

Based-on-patch-from: Borislav Petkov <bp@alien8.de>

and/or by adding you as a copyright holder to one of the files.

Thanks,

	Ingo
