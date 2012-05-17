Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967584Ab2EQSoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 14:44:18 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:28758 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967533Ab2EQSoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 14:44:16 -0400
X-SpamScore: 0
X-BigFish: VS0(zz98dKzz1202h1082kzzz2dh2a8h668h839hd25he5bh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4FB546FB.807@freescale.com>
Date: Thu, 17 May 2012 13:44:11 -0500
From: Timur Tabi <b04825@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: Re: Build regressions/improvements in v3.4-rc7
References: <1337157034-22773-1-git-send-email-geert@linux-m68k.org> <CAMuHMdUtL4_mv-e-EQAZmNcb9dAT=PXB59i7Vuj2vf8NnaBFzQ@mail.gmail.com> <1337212281.30558.17.camel@pasglop> <4FB535D3.7000106@freescale.com> <CAOZdJXW2jmFG8hkBRMAsO-CJ3ruMd28LqS0b-BGZTU7FnpRi3Q@mail.gmail.com> <CAMuHMdVszy2sk6f045krqr=PPQFnd-GrtJYJMQCCPzkq-65psg@mail.gmail.com>
In-Reply-To: <CAMuHMdVszy2sk6f045krqr=PPQFnd-GrtJYJMQCCPzkq-65psg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> powerpc randconfig

Doesn't this generate a different .config every time it's run?  Do I keep
generating random .config files until the problem shows up?

-- 
Timur Tabi
Linux kernel developer at Freescale

