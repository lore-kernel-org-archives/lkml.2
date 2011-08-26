Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab1HZGso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 02:48:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60724 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1HZGsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 02:48:43 -0400
Date: Fri, 26 Aug 2011 10:48:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Ralf Jung <ralfjung-e@gmx.de>, Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
Message-ID: <20110826064838.GB3903@sun>
References: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com>
 <1314315225.16133.30.camel@sbsiddha-desk.sc.intel.com>
 <CAErSpo7N3UBJgQTb+zePnsf5YuFSQT8zy9CftwceyAKKfcHUjA@mail.gmail.com>
 <4E56F9E5.4000005@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E56F9E5.4000005@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 06:41:57PM -0700, H. Peter Anvin wrote:
> On 08/25/2011 05:17 PM, Bjorn Helgaas wrote:
> > 
> > If the OS allocated the next 128 bytes to another device, it sounds
> > like it would cause a conflict on Intel boxes.  This must be an area
> > that differs between vendors.  I haven't seen a spec that mentions 256
> > bytes as the required minimum MMIO size for IOAPICs, and apparently
> > the AMD IOAPIC decodes 240 bytes or fewer.
> > 
> 
> For what it's worth, it's probably a bad idea on x86 for the OS to
> allocate addresses in the 0xFExxxxxx range...
> 
> 	-hpa
> 

I rather wonder if there a way to assign a different address for the
watchdog Bjorn referring to. I don't have such machine to test but
seems its base address is configurable via pmio. Just curious.

	Cyrill
