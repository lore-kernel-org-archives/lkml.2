Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab2F2RLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 13:11:52 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:1850
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755912Ab2F2RLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 13:11:51 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1202hzzz2dh2a8h668h839h93fhd25he5bhf0ah)
Message-ID: <4FEDE184.7070109@freescale.com>
Date: Fri, 29 Jun 2012 12:10:28 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: Re: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com> <CAOZdJXWiGOCtP1iJYR2S48XwR2Wpry8+VswctctdVfY9Z+QTiQ@mail.gmail.com> <4FEDD07D.3090103@freescale.com> <4FEDD1F0.1060000@freescale.com> <4FEDD383.40804@freescale.com> <4FEDD3EB.7090606@freescale.com>
In-Reply-To: <4FEDD3EB.7090606@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 11:12 AM, Timur Tabi wrote:
> Scott Wood wrote:
>> Why is this different from anywhere else where we have a list of
>> compatibles to match, often based on various SoCs?  Note that we
>> explicitly want to match only certain SoCs here.
> 
> I was just hoping to find a way to avoid an ever increasing list of
> compatible strings. 

PCI drivers have to put up with it, why should we be different? :-)

> Other posts on this thread imply that this code could
> work for all multi-core e500 parts.

That list covers all multi-core e500v2 parts that I know of.  Corenet
based chips will need a slightly different implementation, since the
registers are different.

-Scott

