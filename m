Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab2F2QEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:04:20 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:30841
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336Ab2F2QES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:04:18 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz98dI1521I1432Izz1202h1082kzzz2dh2a8h668h839hd25he5bhf0ah)
Message-ID: <4FEDD1F0.1060000@freescale.com>
Date: Fri, 29 Jun 2012 11:04:00 -0500
From: Timur Tabi <b04825@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: Re: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com> <CAOZdJXWiGOCtP1iJYR2S48XwR2Wpry8+VswctctdVfY9Z+QTiQ@mail.gmail.com> <4FEDD07D.3090103@freescale.com>
In-Reply-To: <4FEDD07D.3090103@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:

>> I wonder if it's possible to dynamically generate the compatible
>> string by using the SOC name?
> 
> Where are you going to get the SoC name from?

Well, that is why I said "I wonder".   I'm disappointed that the "cpus"
node doesn't help much.  You'd think the name of the CPU would be in the
CPU node somewhere.

-- 
Timur Tabi
Linux kernel developer at Freescale

