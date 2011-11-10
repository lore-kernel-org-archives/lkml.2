Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab1KJURb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 15:17:31 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:43180 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752038Ab1KJUR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 15:17:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAKIwvE4Y9geI/2dsb2JhbAAMOIR9oxGFFQEBAQEDI1UBEAsYAgIFFgsCAgkDAgECAUUGDQEHAQGtcZIGgTCHOIEWBIgPniw
X-IronPort-AV: E=Sophos;i="4.69,490,1315195200"; 
   d="scan'208";a="147440627"
Message-ID: <4EBC3156.2050409@teksavvy.com>
Date: Thu, 10 Nov 2011 15:17:26 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Grundler <grundler@google.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        Michal Marek <mmarek@suse.cz>, Freddy Xin <freddy@asix.com.tw>,
        "ASIX Allan Email [office]" <allan@asix.com.tw>
Subject: Re: [PATCH v2] drivers/net/usb/asix: resync from vendor's copy
References: <4EA89972.5060101@teksavvy.com> <20111026.194045.2019668159403582571.davem@davemloft.net> <4EA8B283.3010105@teksavvy.com> <20111026.221719.2216112919297458522.davem@davemloft.net> <4EB19BBE.5050602@teksavvy.com> <4EBAB8F5.1010101@teksavvy.com> <4EBBD936.40705@teksavvy.com> <CANEJEGuS1w_rPsjOfY8TqP=TewjRLSdEeR+OmaGB3G4LQZg82Q@mail.gmail.com>
In-Reply-To: <CANEJEGuS1w_rPsjOfY8TqP=TewjRLSdEeR+OmaGB3G4LQZg82Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-10 11:54 AM, Grant Grundler wrote:
> ...  and I was certain on their own, ASIX
> wouldn't get that upstream in one shot. No one knows them. No one
> trusts them. Asix never mentioned that they had already hired you to
> do it (and I am pretty sure you could have).

Just to clarify, ASIX did not contract me for any of this.
Rather, another of my clients requires working ASIX USB support,
and approved my working on that at their expense.

I've got working ASIX support now, just not in the mainline kernel.
The code is GPL, so we could stuff it in anyway,
but I think it would be better to do so with the
full cooperation of the nice folks at ASIX.

But for now, they seem happy to prefer feeding patches
only as requested, currently through Grant, rather than
trying to get the in-kernel driver brought fully up to date.

Cheers
