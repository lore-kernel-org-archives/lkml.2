Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967458Ab2EQRbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 13:31:10 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:54387 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758180Ab2EQRbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 13:31:07 -0400
X-SpamScore: -4
X-BigFish: VS-4(zz146fI98dKzz1202hzzz2dh2a8h668h839hd25he5bh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4FB535D3.7000106@freescale.com>
Date: Thu, 17 May 2012 12:30:59 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, <linux-kernel@vger.kernel.org>,
        Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: Re: Re: Build regressions/improvements in v3.4-rc7
References: <1337157034-22773-1-git-send-email-geert@linux-m68k.org>  <CAMuHMdUtL4_mv-e-EQAZmNcb9dAT=PXB59i7Vuj2vf8NnaBFzQ@mail.gmail.com> <1337212281.30558.17.camel@pasglop>
In-Reply-To: <1337212281.30558.17.camel@pasglop>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> Thanks. These are all freescale platforms, the relevant people should be
> already but I've added Scott and Kumar to the CC list just in case.

Seeing how this is my code, I'd say the relevant people were not CC'd. :-)

Anyway, I think I see what the problem is, but it does appear when I use
the normal defconfigs.  What .config was being used?

-- 
Timur Tabi
Linux kernel developer at Freescale

