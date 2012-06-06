Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab2FFSUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:20:17 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:49456
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758048Ab2FFSUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:20:13 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dh2a8h668h839hd25he5bhf0ah)
Message-ID: <4FCF9F45.4090103@freescale.com>
Date: Wed, 6 Jun 2012 13:19:49 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Zhao Chenhui <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <leoli@freescale.com>
Subject: Re: [PATCH v5 2/5] powerpc/85xx: add HOTPLUG_CPU support
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com> <1336737235-15370-2-git-send-email-chenhui.zhao@freescale.com> <4FC933BF.1020901@freescale.com> <20120604110444.GA20676@localhost.localdomain> <4FCCE32F.1060301@freescale.com> <20120605111823.GB22427@localhost.localdomain> <4FCE30B8.2070902@freescale.com> <20120606095910.GB23505@localhost.localdomain>
In-Reply-To: <20120606095910.GB23505@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2012 04:59 AM, Zhao Chenhui wrote:
> On Tue, Jun 05, 2012 at 11:15:52AM -0500, Scott Wood wrote:
>> On 06/05/2012 06:18 AM, Zhao Chenhui wrote:
>>> If user does not enable kexec or hotplug, these codes are redundant.
>>> So use CONFIG_KEXEC and CONFIG_HOTPLUG_CPU to gard them.
>>
>> My point is that these lists tend to grow and be a maintenance pain.
>> For small things it's often better to not worry about saving a few
>> bytes.  For larger things that need to be conditional, define a new
>> symbol rather than growing ORed lists like this.
>>
>> -Scott
> 
> I agree with you in principle. But there are only two config options
> in this patch, and it is unlikely to grow. 

That's what everybody says when these things start. :-)

-Scott

