Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab1HZJjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:39:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62595 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab1HZJjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:39:23 -0400
Date: Fri, 26 Aug 2011 13:39:18 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ralf Jung <ralfjung-e@gmx.de>, Bjorn Helgaas <bhelgaas@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
Message-ID: <20110826093917.GE3903@sun>
References: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com>
 <4E56F9E5.4000005@zytor.com>
 <20110826064838.GB3903@sun>
 <201108261122.33304.ralfjung-e@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108261122.33304.ralfjung-e@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 11:22:32AM +0200, Ralf Jung wrote:
> Hi,
> 
> > I rather wonder if there a way to assign a different address for the
> > watchdog Bjorn referring to. I don't have such machine to test but
> > seems its base address is configurable via pmio. Just curious.
>
> That would be the watchdog in my laptop then, I guess (I'm the reporter of the 
> bug mentioned by Bjorn)? I don't know much about all the inner workings, but 
> if you send me patches I can tell you what they do.
> 
> Kind regards,
> Ralf

Hi Ralf, I can't put that risk on you. Hell knows how it will react
on such reprogramming (which is seems rather a bios duty than kernel).

Bjorn, from where we pick this address at moment, it's obtained via
pci config?

	Cyrill
