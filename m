Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2G0BoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 21:44:23 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:10512
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002Ab2G0BoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 21:44:22 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I1432I1447Izz1202hzz8275bhz2dh2a8h668h839h93fhd25he5bhf0ah107ah)
Message-ID: <5011F25B.7080103@freescale.com>
Date: Thu, 26 Jul 2012 20:43:55 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Li Yang <leoli@freescale.com>
CC: Zhao Chenhui <chenhui.zhao@freescale.com>, <galak@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 0/7] power management patch set
References: <1342788159-27529-1-git-send-email-chenhui.zhao@freescale.com> <CADRPPNSw5Yn7EgHt5fm2vYr+zxC4T+JbsvT812u2JPKELNcA6g@mail.gmail.com>
In-Reply-To: <CADRPPNSw5Yn7EgHt5fm2vYr+zxC4T+JbsvT812u2JPKELNcA6g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 09:02 AM, Li Yang wrote:
> On Fri, Jul 20, 2012 at 8:42 PM, Zhao Chenhui
> <chenhui.zhao@freescale.com> wrote:
>> Changes for v8:
>> * Separated the cpu hotplug patch into three patches, as follows
>>   [PATCH v8 1/7] powerpc/smp: use a struct epapr_spin_table to replace macros
>>   [PATCH v8 2/7] powerpc/smp: add generic_set_cpu_up() to set cpu_state as CPU_UP_PREPARE
>>   [PATCH v8 4/7] powerpc/85xx: add HOTPLUG_CPU support
>>
>> * Replaced magic numbers with macros in "[PATCH 5/7] powerpc/85xx: add sleep and deep sleep support"
>>
>> * no change to the rest of the patch set
> 
> Hi Kumar,
> 
> How about picking about this series for 3.6?  The review seems to
> settle down for this revision.
> 
> 
> Hi Scott,
> 
> Thanks for the review comments provided.  We'd like to get the ACK
> from you for the series if you can.

I ACKed v7; I assume v8 hasn't made anything worse. :-)

I think it's time to merge this, and deal with any issues as they come up.

-Scott


