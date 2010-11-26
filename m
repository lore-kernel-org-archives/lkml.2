Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab0KZAHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 19:07:10 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52473 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab0KZAHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 19:07:08 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: Free memory never fully used, swapping
Cc: kosaki.motohiro@jp.fujitsu.com, Simon Kirby <sim@hostway.ca>,
        Shaohua Li <shaohua.li@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20101125180959.F462.A69D9226@jp.fujitsu.com>
References: <20101125090328.GB14180@hostway.ca> <20101125180959.F462.A69D9226@jp.fujitsu.com>
Message-Id: <20101126090656.B6C7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 26 Nov 2010 09:07:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH] vmscan: don't rewakeup kswapd if zone memory was exhaust
> 
> ---
>  mm/vmscan.c |   18 +++++++++++-------
>  1 files changed, 11 insertions(+), 7 deletions(-)

Ugh, this is buggy. please ignore. 

sorry.



