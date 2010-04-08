Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab0DHEqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 00:46:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52472 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab0DHEqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 00:46:01 -0400
Message-ID: <4BBD5EA4.3080908@zytor.com>
Date: Wed, 07 Apr 2010 21:42:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Yinghai <yinghai.lu@oracle.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, linux-pci@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Andy Isaacson <adi@hexapodia.org>, Thomas Renninger <trenn@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
 as x86_32
References: <20100407210628.28364.96982.stgit@bob.kio>	 <4BBD0B0A.3090702@oracle.com> <201004071705.07176.bjorn.helgaas@hp.com>	 <4BBD13C3.2060404@oracle.com> <1270697054.25226.16.camel@dc7800.home>
In-Reply-To: <1270697054.25226.16.camel@dc7800.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 08:24 PM, Bjorn Helgaas wrote:
> 
> I actually did propose doing something in pci_setup_device(), similar to
> what we already do for legacy IDE resources, but HPA thought it should
> be done in the arch code instead, again for reasons I don't completely
> understand.
> 

"Non-PCI devices" is hard to understand?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

