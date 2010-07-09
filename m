Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab0GIQgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 12:36:47 -0400
Received: from stinky.trash.net ([213.144.137.162]:39966 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab0GIQgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 12:36:45 -0400
Message-ID: <4C37501A.3070807@trash.net>
Date: Fri, 09 Jul 2010 18:36:42 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
       James Morris <jmorris@namei.org>,
       Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, coreteam@netfilter.org,
       netdev@vger.kernel.org, herbert.xu@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] netfilter: add CHECKSUM target
References: <20100708222913.GA4475@redhat.com> <4C373D90.8070000@trash.net> <alpine.LSU.2.01.1007091824520.1835@obet.zrqbmnf.qr>
In-Reply-To: <alpine.LSU.2.01.1007091824520.1835@obet.zrqbmnf.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.07.2010 18:26, schrieb Jan Engelhardt:
> 
> On Friday 2010-07-09 17:17, Patrick McHardy wrote:
>>
>>> This adds a `CHECKSUM' target, which can be used in the iptables mangle
>>> table.
>>>
>>> You can use this target to compute and fill in the checksum in
>>> an IP packet that lacks a checksum.  This is particularly useful,
>>> if you need to work around old applications such as dhcp clients,
>>> that do not work well with checksum offloads, but don't want to
>>> disable checksum offload in your device.
>>
>> I'm not sure this is something we want to merge upstream and
>> support indefinitely.
> 
> We could put it into Xtables-addons. That would also be consistent
> with Dave's suggestion.

Sure, that would be fine with me.
