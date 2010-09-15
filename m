Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0IOVuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 17:50:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52649 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab0IOVus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 17:50:48 -0400
Message-ID: <4C913F96.4020106@zytor.com>
Date: Wed, 15 Sep 2010 14:50:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] PCI: allocate bus resources from the top down
References: <20100915210818.12365.58732.stgit@bob.kio> <20100915210912.12365.78836.stgit@bob.kio>
In-Reply-To: <20100915210912.12365.78836.stgit@bob.kio>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2010 02:09 PM, Bjorn Helgaas wrote:
> 
> On the machine above (a Dell T3500), the [mem 0xbff00000-0xbfffffff] region
> doesn't actually work and is likely a BIOS defect.  The symptom is that we
> move the AHCI controller to 0xbff00000, which leads to "Boot has failed,
> sleeping forever," a BUG in ahci_stop_engine(), or some other boot failure.
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>

... for the patch in general, but I would like to *also* request a DMA
or PCI quirk to explicitly reserve the above range on the affected Dell
machines.

	-hpa
