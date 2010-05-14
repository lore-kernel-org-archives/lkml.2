Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086Ab0ENXlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 19:41:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36365 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab0ENXlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 19:41:20 -0400
Message-ID: <4BEDDF87.4040309@zytor.com>
Date: Fri, 14 May 2010 16:40:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Mike Travis <travis@sgi.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Mike Habeck <habeck@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai <yinghai.lu@oracle.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Myron Stowe <myron.stowe@hp.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com>	<201005131256.17997.bjorn.helgaas@hp.com>	<4BEC5530.1000008@sgi.com>	<201005131402.30759.bjorn.helgaas@hp.com>	<20100514152509.3aeb37b4@virtuousgeek.org>	<4BEDCFD9.7020202@sgi.com>	<20100514154706.4f36f4ed@virtuousgeek.org>	<4BEDD5BF.5030005@sgi.com>	<20100514160651.2b4ee3d7@virtuousgeek.org>	<4BEDDB88.6000608@sgi.com> <20100514163347.52822fcb@virtuousgeek.org>
In-Reply-To: <20100514163347.52822fcb@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2010 04:33 PM, Jesse Barnes wrote:
> 
> As for BIOS coordination for dynamic reallocation, yeah there'd be some
> of that.  I think the basic principles would be:
>   1) use BIOS allocations wherever possible
>   2) get an accurate list of available resources from the BIOS for
>      potential remapping later
>   3) allocate resources for BARs and devices as late as possible (e.g.
>      at driver bind time) to avoid allocating more than we need
> 
> But that's a good chunk of work, and as we've seen, PCs in particular
> are really sensitive to having resources moved around too much, so step
> (2) is probably the hardest part.
> 

The real problem that I see, as outlined before, has nothing to do with
the BIOS, but rather the interdependencies between resources.

	-hpa

