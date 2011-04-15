Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab1DOPbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 11:31:08 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:60590 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754592Ab1DOPbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 11:31:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBABRkqE1Ld/sX/2dsb2JhbAAMhEPVMZEogSmDTXgElCs
X-IronPort-AV: E=Sophos;i="4.64,219,1301889600"; 
   d="scan'208";a="106517741"
Message-ID: <4DA864A2.3020804@teksavvy.com>
Date: Fri, 15 Apr 2011 11:30:42 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mikael Abrahamsson <swmike@swm.pp.se>
CC: Bruce Stenning <b.stenning@indigovision.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com> <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com> <4D9CD275.9000002@teksavvy.com> <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com> <alpine.DEB.2.00.1104150510181.14027@uplift.swm.pp.se> <4DA7BC4B.9090104@teksavvy.com> <alpine.DEB.2.00.1104150941220.14027@uplift.swm.pp.se> <4DA83BAF.2010801@teksavvy.com> <alpine.DEB.2.00.1104151603460.14027@uplift.swm.pp.se>
In-Reply-To: <alpine.DEB.2.00.1104151603460.14027@uplift.swm.pp.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-15 10:04 AM, Mikael Abrahamsson wrote:
> On Fri, 15 Apr 2011, Mark Lord wrote:
> 
>> Mikael -- any chance you could someday retry this on 2.6.38.2 ?
> 
> Well, since the problem went away after I re-seated the SATA cable, I don't
> think I'll even be able to reproduce it with 2.6.32.


Right.  Thanks.
