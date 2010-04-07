Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab0DGSmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 14:42:24 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:52759 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab0DGSmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 14:42:23 -0400
Date: Wed, 7 Apr 2010 11:42:23 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset
	failed (0xffffffff)
Message-ID: <20100407184223.GJ29192@hexapodia.org>
References: <20100406225425.GA8292@hexapodia.org> <1270614080.8518.26.camel@dc7800.home> <20100407171610.GH29192@hexapodia.org> <201004071208.50483.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004071208.50483.bjorn.helgaas@hp.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 12:08:49PM -0600, Bjorn Helgaas wrote:
> On Wednesday 07 April 2010 11:16:10 am Andy Isaacson wrote:
> > On Tue, Apr 06, 2010 at 10:21:20PM -0600, Bjorn Helgaas wrote:
> > > > The machine only has Linux installed, but I may have access to another
> > > > T3400 that can dual-boot.  Any preference for XP versus Win7?
> > > 
> > > Nope, whatever's more convenient for you should be fine.
> > 
> > On another T3400 with BIOS A03, Win7's Device Manager -> IDE ATA/ATAPI
> > controllers -> Standard AHCI 1.0 -> Resources -> Memory Range setting is
> > ff97f800-ff97ffff.
> 
> Assuming this is the same AHCI controller (probably is, because I only
> see one mentioned in your logs), I think Win7 moved it from where BIOS

Yes, there's only one AHCI controller mentioned on either machine.

-andy
