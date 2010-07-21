Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762658Ab0GUGfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 02:35:24 -0400
Received: from borg.medozas.de ([188.40.89.202]:51056 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762641Ab0GUGfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 02:35:21 -0400
Date: Wed, 21 Jul 2010 08:35:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Simon Horman <horms@verge.net.au>
cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Malcolm Turnbull <malcolm@loadbalancer.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Julius Volz <julius.volz@gmail.com>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hannes Eder <heder@google.com>
Subject: Re: [patch v2.6 4/4] libxt_ipvs: user-space lib for netfilter matcher
 xt_ipvs
In-Reply-To: <20100721012146.GC22966@verge.net.au>
Message-ID: <alpine.LSU.2.01.1007210834570.10568@obet.zrqbmnf.qr>
References: <20100711090342.035149543@vergenet.net> <20100711090500.421568837@vergenet.net> <20100721012146.GC22966@verge.net.au>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2010-07-21 03:21, Simon Horman wrote:
>> +
>> +#define XT_IPVS_IPVS_PROPERTY	(1 << 0) /* all other options imply this one */
>> +#define XT_IPVS_PROTO		(1 << 1)
>> +#define XT_IPVS_VADDR		(1 << 2)
>> +#define XT_IPVS_VPORT		(1 << 3)
>> +#define XT_IPVS_DIR		(1 << 4)
>> +#define XT_IPVS_METHOD		(1 << 5)
>> +#define XT_IPVS_VPORTCTL	(1 << 6)
>> +#define XT_IPVS_MASK		((1 << 7) - 1)
>> +#define XT_IPVS_ONCE_MASK	(XT_IPVS_MASK & ~XT_IPVS_IPVS_PROPERTY)

Can't these just be an enum?

