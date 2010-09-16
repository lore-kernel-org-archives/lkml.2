Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab0IPUDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:03:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43932 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428Ab0IPUDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:03:04 -0400
Message-ID: <4C9277CF.6070209@zytor.com>
Date: Thu, 16 Sep 2010 13:02:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] PCI: allocate bus resources from the top down
References: <20100915210818.12365.58732.stgit@bob.kio> <201009151644.38563.bjorn.helgaas@hp.com> <4C915AB2.9090203@zytor.com> <201009161104.15665.bjorn.helgaas@hp.com> <4C925768.7040707@zytor.com> <4C92710D.3040401@kernel.org>
In-Reply-To: <4C92710D.3040401@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2010 12:33 PM, Yinghai Lu wrote:
> 
> Those Dell machine BIOS set wrong value in the pci bridge. and it is partial
> overlapped with reserved range in e820.
> 
> Kernel current will honor that HW setting from pci bridge reading at first.
> 
> so the best way should be: using e820 reserved range to trim reading from pci or acpi in some cases.
> 

Yes, that's the only sane option.

	-hpa
