Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967610Ab2EQSsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 14:48:36 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:9121
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967531Ab2EQSse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 14:48:34 -0400
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dh2a8h668h839hd25he5bh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4FB547F9.7000804@freescale.com>
Date: Thu, 17 May 2012 13:48:25 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Timur Tabi <b04825@freescale.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: Re: Build regressions/improvements in v3.4-rc7
References: <1337157034-22773-1-git-send-email-geert@linux-m68k.org> <CAMuHMdUtL4_mv-e-EQAZmNcb9dAT=PXB59i7Vuj2vf8NnaBFzQ@mail.gmail.com> <1337212281.30558.17.camel@pasglop> <4FB535D3.7000106@freescale.com> <CAOZdJXW2jmFG8hkBRMAsO-CJ3ruMd28LqS0b-BGZTU7FnpRi3Q@mail.gmail.com> <CAMuHMdVszy2sk6f045krqr=PPQFnd-GrtJYJMQCCPzkq-65psg@mail.gmail.com> <4FB546FB.807@freescale.com>
In-Reply-To: <4FB546FB.807@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 01:44 PM, Timur Tabi wrote:
> Geert Uytterhoeven wrote:
>> powerpc randconfig
> 
> Doesn't this generate a different .config every time it's run?  Do I keep
> generating random .config files until the problem shows up?
> 

Regardless of the config that shows this, the MSR[GS] check should go
away.  If you have a /hypervisor node, you already know you're a guest.

-Scott

