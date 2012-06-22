Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762688Ab2FVVSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:18:34 -0400
Received: from 1wt.eu ([62.212.114.60]:3405 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622Ab2FVVSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:18:32 -0400
Date: Fri, 22 Jun 2012 23:18:24 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, lwn@lwn.net,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Linux 2.6.32.55
Message-ID: <20120622211824.GB18996@1wt.eu>
References: <20120125223434.GA31647@kroah.com> <4FE4C1A3.4080804@suse.cz> <20120622193824.GA3371@kroah.com> <4FE4DF41.30400@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE4DF41.30400@suse.cz>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 11:10:25PM +0200, Jiri Slaby wrote:
> On 06/22/2012 09:38 PM, Greg KH wrote:
> > On Fri, Jun 22, 2012 at 09:04:03PM +0200, Jiri Slaby wrote:
> >> On 01/25/2012 11:34 PM, Greg KH wrote:
> >>> I'm announcing the release of the 2.6.32.55 kernel.
> >> ...
> >>> Bjorn Helgaas (1): PNP: work around Dell 1536/1546 BIOS MMCONFIG
> >>> bug that breaks USB
> >>
> >> Hi, this one is dependant on 24d25dbfa63c3 (x86/PCI: amd: factor out
> >> MMCONFIG discovery), otherwise amd_get_mmconfig_range is undefined...
> > 
> > Interesting that this was reported almost 6 months after it was released :)
> 
> Yes :). This is because it is inside #ifdef CONFIG_AMD_NB which perhaps
> nobody has set in 2.6.32. (Other than that we have the kernel in suse
> enterprise for some time already.)
> 
> @Willy: 24d25dbfa63c3 is not enough. The header referenced in
> 2.6.32.55's patch does not exist in that tree yet. It was renamed from
> asm/k8.h to asm/amd_nb.h later (by 23ac4ae827e62).
> 
> Given nobody noticed till now, I would incline to drop that patch from
> 2.6.32 series. Opinions?

Which one would you drop then ? You got me lost now. I mean, since you've
been the only one to notice an issue, I have no problem with following you
on the best way to fix it but I need to understand what you want then :-)

Thanks,
Willy

