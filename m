Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab0FNVLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:11:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60234 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418Ab0FNVLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:11:03 -0400
Message-ID: <4C169ABC.1090406@zytor.com>
Date: Mon, 14 Jun 2010 14:10:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Yinghai Lu <yinghai.lu@oracle.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Graham Ramsey <ramsey.graham@ntlworld.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Robert Richter <robert.richter@amd.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       Joseph Chan <JosephChan@via.com.tw>, Jiri Slaby <jslaby@suse.cz>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH -v2] x86, pci: Handle fallout pci devices with peer root
 bus
References: <4BF40014.30303@ntlworld.com> <201006141400.22653.bjorn.helgaas@hp.com> <4C168C45.8060106@zytor.com> <201006141420.15799.bjorn.helgaas@hp.com>
In-Reply-To: <201006141420.15799.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 01:20 PM, Bjorn Helgaas wrote:
> 
> OK, but Graham's system doesn't have anything resembling a PCI-to-PCI
> bridge leading to bus 80.  So while I agree that in an ideal world,
> HT/PCI host bridges might always look like PCI-to-PCI bridges, it
> seems this is not the case in practice.
> 

Invisible PCI bridges have been known to occur in pure PCI space, too.

> Yes, absolutely.  My point is that what the HT spec means by "host bridge"
> is not the same as what the PCI spec and Linux mean by "PCI host bridge".

Actually, they're *exactly* the same thing.

	-hpa
