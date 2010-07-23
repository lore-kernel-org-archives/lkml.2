Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0GWKo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 06:44:57 -0400
Received: from stinky.trash.net ([213.144.137.162]:35110 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab0GWKoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 06:44:54 -0400
Message-ID: <4C4972A3.7070508@trash.net>
Date: Fri, 23 Jul 2010 12:44:51 +0200
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
Subject: Re: [patch v2.8 1/4] netfilter: xt_ipvs (netfilter matcher for IPVS)
References: <20100722073547.504156161@vergenet.net> <20100722075012.385241097@vergenet.net>
In-Reply-To: <20100722075012.385241097@vergenet.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.07.2010 09:35, schrieb Simon Horman:
> From:	Hannes Eder <heder@google.com>
> 
> This implements the kernel-space side of the netfilter matcher xt_ipvs.
> 
> [ minor fixes by Simon Horman <horms@verge.net.au> ]
> Signed-off-by: Hannes Eder <heder@google.com>
> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> --- 
> 
>  include/linux/netfilter/xt_ipvs.h |   27 ++++
>  net/netfilter/Kconfig             |   10 +
>  net/netfilter/Makefile            |    1 
>  net/netfilter/ipvs/ip_vs_proto.c  |    1 
>  net/netfilter/xt_ipvs.c           |  189 +++++++++++++++++++++++++++++++++++++

I added xt_ipvs.h to Kbuild and applied the patch, thanks.
