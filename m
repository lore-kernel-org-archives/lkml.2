Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0IVWxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 18:53:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:58617 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab0IVWxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 18:53:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,220,1283756400"; 
   d="scan'208";a="609475314"
Message-ID: <4C9A88F3.7080802@linux.intel.com>
Date: Wed, 22 Sep 2010 15:53:39 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, simon@fire.lp0.eu, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/pci] x86, pci: Ignore any PCI BARs that match an HPET
 we already know about
References: <20100922201547.3197.33702.stgit@bob.kio> <tip-e72a6c8f7ac715a9cdb473afbc30743348d0a1e2@git.kernel.org> <4C9A79BC.6020305@kernel.org> <201009221641.35871.bjorn.helgaas@hp.com>
In-Reply-To: <201009221641.35871.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 03:41 PM, Bjorn Helgaas wrote:
>>
>> It seems there is some problem here:
>>
>> hpet_res is inserted to resource with late_initcall().
>> so if you don't touch that hpet address in bar and not put in the resource.
>> kernel could allocate that address to other devices that doesn't get resource from BIOS.
> 
> Hmm, yes, that's a problem.  Let me look into it tomorrow; maybe we
> can do something like setting IORESOURCE_PCI_FIXED instead of just
> clearing out the resource.
> 
> Bjorn

OK, dropping the patch for now.

	-hpa
