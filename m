Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab2LFJKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:10:46 -0500
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:14820
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268Ab2LFJKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:10:42 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1de0h1202h1d1ah1d2ahzz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 6 Dec 2012 17:37:28 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
CC: <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <mturquette@linaro.org>
Subject: Re: [PATCH 6/6 v8] cpufreq, highbank: add support for highbank
 cpufreq
Message-ID: <20121206093726.GB27003@S2100-06.ap.freescale.net>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354726121-17190-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354726121-17190-7-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1354726121-17190-7-git-send-email-mark.langsdorf@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 10:48:41AM -0600, Mark Langsdorf wrote:
> Highbank processors depend on the external ECME to perform voltage
> management based on a requested frequency. Communication between the
> A9 cores and the ECME happens over the pl320 IPC channel.
> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> Cc: shawn.guo@linaro.org

Reviewed-by: Shawn Guo <shawn.guo@linaro.org>

