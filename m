Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab2FFSam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:30:42 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:31675
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754294Ab2FFSak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:30:40 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fhd25he5bhf0ah)
Message-ID: <4FCFA17F.3050207@freescale.com>
Date: Wed, 6 Jun 2012 13:29:19 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Li Yang <leoli@freescale.com>
CC: Wood Scott-B07421 <B07421@freescale.com>,
        Li Yang-R58472 <r58472@freescale.com>,
        Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v5 4/5] fsl_pmc: Add API to enable device as wakeup event
 source
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com> <1336737235-15370-4-git-send-email-chenhui.zhao@freescale.com> <4FC93D74.3090200@freescale.com> <20120604113609.GC20676@localhost.localdomain> <4FCD3E8B.30805@freescale.com> <94F013E7935FF44C83EBE7784D62AD3F09335D27@039-SN2MPN1-022.039d.mgd.msft.net> <4FCE2FB8.9080307@freescale.com> <94F013E7935FF44C83EBE7784D62AD3F093360C1@039-SN2MPN1-022.039d.mgd.msft.net> <4FCE4A5A.3020603@freescale.com> <CADRPPNSzTNPkNExBnNu1iD2hqyRG=Cw+y+PnjTRWxjP_ib1Kww@mail.gmail.com>
In-Reply-To: <CADRPPNSzTNPkNExBnNu1iD2hqyRG=Cw+y+PnjTRWxjP_ib1Kww@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 11:06 PM, Li Yang wrote:
> On Wed, Jun 6, 2012 at 2:05 AM, Scott Wood <scottwood@freescale.com> wrote:
>> You ignored "what about devices other than ethernet".
> 
> No, I haven't.  Other devices are so at least for now.

I don't understand that last sentence.  Other devices are what?

-Scott

