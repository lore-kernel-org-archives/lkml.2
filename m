Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab0GWKrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 06:47:33 -0400
Received: from stinky.trash.net ([213.144.137.162]:35169 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0GWKrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 06:47:31 -0400
Message-ID: <4C497340.1010305@trash.net>
Date: Fri, 23 Jul 2010 12:47:28 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Malcolm Turnbull <malcolm@loadbalancer.org>,
        Mark Brooks <mark@loadbalancer.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Julius Volz <julius.volz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hannes Eder <heder@google.com>, Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [patch v2.8 2/4] IPVS: make friends with nf_conntrack
References: <20100722073547.504156161@vergenet.net> <20100722075012.658190199@vergenet.net>
In-Reply-To: <20100722075012.658190199@vergenet.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.07.2010 09:35, schrieb Simon Horman:
> Update the nf_conntrack tuple in reply direction, as we will see
> traffic from the real server (RIP) to the client (CIP).  Once this is
> done we can use netfilters SNAT in POSTROUTING, especially with
> xt_ipvs, to do source NAT, e.g.:
> 
> % iptables -t nat -A POSTROUTING -m ipvs --vaddr 192.168.100.30/32 --vport 80 \
>> > -j SNAT --to-source 192.168.10.10

Applied, thanks.
