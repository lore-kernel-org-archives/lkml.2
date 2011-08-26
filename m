Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab1HZQYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 12:24:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53153 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870Ab1HZQYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 12:24:40 -0400
Message-ID: <4E57C8A9.1070301@zytor.com>
Date: Fri, 26 Aug 2011 09:24:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Ralf Jung <ralfjung-e@gmx.de>, Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
References: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com> <1314315225.16133.30.camel@sbsiddha-desk.sc.intel.com> <CAErSpo7N3UBJgQTb+zePnsf5YuFSQT8zy9CftwceyAKKfcHUjA@mail.gmail.com> <20110826062224.GA3903@sun> <CAErSpo66U-La7AXCraENWOUvQAuCECRT_eGvJmxC-S4BrN=yAA@mail.gmail.com>
In-Reply-To: <CAErSpo66U-La7AXCraENWOUvQAuCECRT_eGvJmxC-S4BrN=yAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2011 09:21 AM, Bjorn Helgaas wrote:
> 
> Is there some spec that requires all IOAPICs to be 1K aligned?  I
> don't doubt that's the case; I'd just like to see something more
> concrete than folklore.  I'm pretty sure there's some (possibly
> secret) "IOAPIC architecture spec," and a section reference to it
> would be nice.  Even before my patch, I don't think we actually
> checked or enforced any *alignment* -- we only set the size.  I don't
> know if it's worth it unless we have a problem it would fix, and it's
> conceivable that we'd start warning about a perfectly functional
> IOAPIC that's 128-byte aligned.
> 

The PIIX3 IOAPIC decoder could only decode addresses on a 1K
granularity, but I don't think that was architectural.  I will try to ask.

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

