Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800Ab0ENWgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:36:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46126 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497Ab0ENWgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 18:36:12 -0400
Message-ID: <4BEDD03B.30106@zytor.com>
Date: Fri, 14 May 2010 15:35:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Mike Habeck <habeck@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Jacob Pan <jacob.jun.pan@intel.com>,
       Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai <yinghai.lu@oracle.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Myron Stowe <myron.stowe@hp.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com>	<201005131256.17997.bjorn.helgaas@hp.com>	<4BEC5530.1000008@sgi.com>	<201005131402.30759.bjorn.helgaas@hp.com> <20100514152509.3aeb37b4@virtuousgeek.org> <4BEDCFD9.7020202@sgi.com>
In-Reply-To: <4BEDCFD9.7020202@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2010 03:34 PM, Mike Travis wrote:
> 
> It seems that BIOS changes are much more difficult.  The real solution
> to this problem is for Card Vendors to not request I/O Bars if they
> won't be using them.  But that's the hardest option of all to accomplish.
> 

That is a non-option.  Any device which may have to be a boot or console
device in a legacy system pretty much needs them.

	-hpa
