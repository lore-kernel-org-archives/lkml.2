Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab1HZJ4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:56:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58449 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab1HZJ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:56:37 -0400
Date: Fri, 26 Aug 2011 13:56:31 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ralf Jung <ralfjung-e@gmx.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
Message-ID: <20110826095631.GF3903@sun>
References: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com>
 <201108261122.33304.ralfjung-e@gmx.de>
 <20110826093917.GE3903@sun>
 <201108261153.21103.ralfjung-e@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108261153.21103.ralfjung-e@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 11:53:20AM +0200, Ralf Jung wrote:
> Hi, 
> 
> > Hi Ralf, I can't put that risk on you. Hell knows how it will react
> > on such reprogramming (which is seems rather a bios duty than kernel).
>
> Oh, we are talking about that kind of problems? It's my main (and only) work 
> laptop, so... thanks for the warning ;-)
> 

Yeah, i'm just curious ;) Anyway, Bjorn's patch fixes your problem
and the warn_on I proposed might be added later, on top of this
patch.

	Cyrill
