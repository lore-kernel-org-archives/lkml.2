Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab1DODcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 23:32:32 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:42627 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754161Ab1DODca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 23:32:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAEy7p01Ld/sX/2dsb2JhbAAMhELVUpEwgSmDTXgElB8
X-IronPort-AV: E=Sophos;i="4.64,215,1301889600"; 
   d="scan'208";a="106481476"
Message-ID: <4DA7BC4B.9090104@teksavvy.com>
Date: Thu, 14 Apr 2011 23:32:27 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mikael Abrahamsson <swmike@swm.pp.se>
CC: Bruce Stenning <b.stenning@indigovision.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com> <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com> <4D9CD275.9000002@teksavvy.com> <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com> <alpine.DEB.2.00.1104150510181.14027@uplift.swm.pp.se>
In-Reply-To: <alpine.DEB.2.00.1104150510181.14027@uplift.swm.pp.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-14 11:15 PM, Mikael Abrahamsson wrote:
> On Fri, 8 Apr 2011, Bruce Stenning wrote:
> 
>> The 2.6.38.2 kernel still exhibits the same lockups that we see with the
>> 2.6.26 kernel.
> 
> Hi.
> 
> I have some input on this. I have one of these controllers and had problems with
> one channel where if I had a drive in that hotswap bay, the controller wouldn't
> even POST at boot. It just stuck in the detection phase in the controller BIOS.
> 
> When I tested hotplugging into that bay when the system was running, I received
> a kernel warning (it's not powered on at the moment so I can't provide the
> output, if it's important I can get it).

I would like to see the output, next time you can get it.

The thing with the 6041 chip, is that I actually have all of the Marvell
documentation and errata info for the chip.  So in theory, we know everything
about it, and there are no secret failure modes yet to be discovered.
The sata_mv driver does not depend on the board's BIOS for anything either.

That's the theory, anyway.  :)

Cheers
