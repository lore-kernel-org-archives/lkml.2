Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0GVGZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 02:25:07 -0400
Received: from borg.medozas.de ([188.40.89.202]:49938 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab0GVGZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 02:25:04 -0400
Date: Thu, 22 Jul 2010 08:25:01 +0200 (CEST)
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
In-Reply-To: <20100722013817.GB15008@verge.net.au>
Message-ID: <alpine.LSU.2.01.1007220823340.4980@obet.zrqbmnf.qr>
References: <20100711090342.035149543@vergenet.net> <20100711090500.421568837@vergenet.net> <20100721012146.GC22966@verge.net.au> <alpine.LSU.2.01.1007210834570.10568@obet.zrqbmnf.qr> <20100721132159.GN6418@verge.net.au> <alpine.LSU.2.01.1007211526490.25445@obet.zrqbmnf.qr>
 <20100721134102.GA21188@verge.net.au> <20100722013817.GB15008@verge.net.au>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2010-07-22 03:38, Simon Horman wrote:
>
>I must confess that I'm not familiar with using enum in this way.
>Can I confirm that you are suggesting the following?
>
>enum {
>	XT_IPVS_IPVS_PROPERTY =	1 << 0, /* all other options imply this one */
>	XT_IPVS_PROTO =		1 << 1,
>	XT_IPVS_VADDR =		1 << 2,
>	XT_IPVS_VPORT =		1 << 3,
>	XT_IPVS_DIR =		1 << 4,
>	XT_IPVS_METHOD =	1 << 5,
>	XT_IPVS_VPORTCTL =	1 << 6,
>	XT_IPVS_MASK =		(1 << 7) - 1,
>	XT_IPVS_ONCE_MASK =	(XT_IPVS_MASK & ~XT_IPVS_IPVS_PROPERTY)
>};

Yes; You may drop the () in ONCE_MASK though.
