Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762658Ab2FVTiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 15:38:18 -0400
Received: from 1wt.eu ([62.212.114.60]:3398 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756409Ab2FVTiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 15:38:17 -0400
Date: Fri, 22 Jun 2012 21:38:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, lwn@lwn.net,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Linux 2.6.32.55
Message-ID: <20120622193807.GA18996@1wt.eu>
References: <20120125223434.GA31647@kroah.com> <4FE4C1A3.4080804@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE4C1A3.4080804@suse.cz>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri!

On Fri, Jun 22, 2012 at 09:04:03PM +0200, Jiri Slaby wrote:
> On 01/25/2012 11:34 PM, Greg KH wrote:
> > I'm announcing the release of the 2.6.32.55 kernel.
> ...
> > Bjorn Helgaas (1): PNP: work around Dell 1536/1546 BIOS MMCONFIG
> > bug that breaks USB
> 
> Hi, this one is dependant on 24d25dbfa63c3 (x86/PCI: amd: factor out
> MMCONFIG discovery), otherwise amd_get_mmconfig_range is undefined...

Thanks for the info, I'm queuing this one right now for .60.

Thanks,
Willy

