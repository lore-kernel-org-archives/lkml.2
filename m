Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab0GIQ0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 12:26:38 -0400
Received: from borg.medozas.de ([188.40.89.202]:58080 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757308Ab0GIQ0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 12:26:36 -0400
Date: Fri, 9 Jul 2010 18:26:34 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Patrick McHardy <kaber@trash.net>
cc: "Michael S. Tsirkin" <mst@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
       James Morris <jmorris@namei.org>,
       Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, coreteam@netfilter.org,
       netdev@vger.kernel.org, herbert.xu@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] netfilter: add CHECKSUM target
In-Reply-To: <4C373D90.8070000@trash.net>
Message-ID: <alpine.LSU.2.01.1007091824520.1835@obet.zrqbmnf.qr>
References: <20100708222913.GA4475@redhat.com> <4C373D90.8070000@trash.net>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2010-07-09 17:17, Patrick McHardy wrote:
>
>> This adds a `CHECKSUM' target, which can be used in the iptables mangle
>> table.
>> 
>> You can use this target to compute and fill in the checksum in
>> an IP packet that lacks a checksum.  This is particularly useful,
>> if you need to work around old applications such as dhcp clients,
>> that do not work well with checksum offloads, but don't want to
>> disable checksum offload in your device.
>
>I'm not sure this is something we want to merge upstream and
>support indefinitely.

We could put it into Xtables-addons. That would also be consistent
with Dave's suggestion.

>Dave suggested this as a temporary
>out-of-tree workaround until the majority of guest dhcp clients
>are fixed. Has anything changed that makes this course of
>action impractical?
