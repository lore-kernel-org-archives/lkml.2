Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab0HCBKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 21:10:04 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:33584 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab0HCBJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 21:09:59 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] iBFT features for v2.6.36
Date: Mon, 2 Aug 2010 21:08:03 -0400
User-Agent: KMail/1.9.10
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek <konrad@hera.kernel.org>,
        torvalds@linux-foundation.org, James.Bottomley@suse.de,
        linux-kernel@vger.kernel.org, pjones@redhat.com, lenb@kernel.org,
        michaelc@cs.wisc.edu
References: <20100802143642.GA15428@hera.kernel.org> <20100802195248.GB32503@andromeda.dapyr.net> <4C572A13.4010303@zytor.com>
In-Reply-To: <4C572A13.4010303@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008022108.04024.konrad@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 August 2010 16:26:59 H. Peter Anvin wrote:
> On 08/02/2010 12:52 PM, Konrad Rzeszutek Wilk wrote:
> >> Unfortunately, we're increasingly seeing a proliferation of this kind of
> >> nonstandard ACPI tables, because it is difficult to add data to ACPI at
> >
> > Keep in mind that iBFT is now a standard (woot!)
>
> Yes, but the discovery method is ad hoc, as opposed to the standard ACPI
> mechanisms.

The set of patches that I am asking Linus to pull now can use the ACPI table 
to find the table or in the fallback case the old method of scanning the 
memory. However if the machine has UEFI it will only do ACPI table lookup.

Can you point me what 'standard ACPI mechanism' is? Like sticking the code in 
the drivers/acpi ? And then having a generic driver to handle the 
[i,a,s,m]BFT tables and maybe some subordinate ones for specific pieces where 
the generic can't handle it?

> >> It would be good to have some kind of common structure framework for
> >> these.
> >
> > I need to grok those tables some more to figure out what they all do.
>
> More or less the same thing as iBFT, but for AoE, SRP, or in-memory disk.

What is the tools state ? For iBFT, iscsi-initiator-utils scans 
the /sys/firmware directory to extract the relevant data and does its thing. 
Are there tools for AoE, SCSI RDMA Protocol (SRP), and in-memory disk?
