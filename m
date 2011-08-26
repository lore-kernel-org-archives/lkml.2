Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab1HZTP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 15:15:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57741 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab1HZTPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 15:15:53 -0400
Date: Fri, 26 Aug 2011 23:15:47 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Ralf Jung <ralfjung-e@gmx.de>, Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
Message-ID: <20110826191547.GB1930@sun>
References: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com>
 <1314315225.16133.30.camel@sbsiddha-desk.sc.intel.com>
 <CAErSpo7N3UBJgQTb+zePnsf5YuFSQT8zy9CftwceyAKKfcHUjA@mail.gmail.com>
 <20110826062224.GA3903@sun>
 <CAErSpo66U-La7AXCraENWOUvQAuCECRT_eGvJmxC-S4BrN=yAA@mail.gmail.com>
 <20110826180930.GA1930@sun>
 <4E57E441.6030800@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E57E441.6030800@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 11:21:53AM -0700, H. Peter Anvin wrote:
...
> > 
> > Ie -- 4K increment with 1K base address. If I find other sources I have in mind
> > I'll ping you.
> > 
> 
> OK, so that explicitly specifies a 1K alignment.  The 4K bit seems to be
> a default policy and not a requirement.
> 
> 	-hpa
> 

Yeah, and I seem to overdid with warning proposal ;)
So patch is fune, thanks a lot Bjorn!

	Cyrill
