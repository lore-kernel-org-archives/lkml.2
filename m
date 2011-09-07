Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab1IGREt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:04:49 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:24421
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754855Ab1IGREq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:04:46 -0400
X-SpamScore: -15
X-BigFish: VS-15(zzbb2dK9371K1432N98dKzz1202hzz8275bh8275dhz2dh87h668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
Message-ID: <4E67A417.3000309@infradead.org>
Date: Wed, 7 Sep 2011 10:04:23 -0700
From: Geoff Levand <geoff@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@elte.hu>,
        <linuxppc-dev@lists.ozlabs.org>, <cbe-oss-dev@lists.ozlabs.org>
Subject: Re: [PATCH 51/62] powerpc/ps3: irq: Remove IRQF_DISABLED
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com> <1315383059-3673-52-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1315383059-3673-52-git-send-email-yong.zhang0@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 01:10 AM, Yong Zhang wrote:
> This flag is a NOOP and can be removed now.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---
>  drivers/ps3/ps3-vuart.c   |    2 +-
>  drivers/ps3/ps3stor_lib.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Acked-by: Geoff Levand <geoff@infradead.org>

