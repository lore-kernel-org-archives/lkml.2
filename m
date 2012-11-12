Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab2KLVv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:51:26 -0500
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:46640
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878Ab2KLVvZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:51:25 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1de0h1202h1d1ah1d2ahzz8275dhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h1155h)
Date: Mon, 12 Nov 2012 15:51:06 -0600
From: Scott Wood <scottwood@freescale.com>
Subject: Re: Build regressions/improvements in v3.7-rc5
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <CAMuHMdXE0yJNivpirGgx08zqLH2086ydeOU6zswXj-+zn8OsWQ@mail.gmail.com>
	(from geert@linux-m68k.org on Mon Nov 12 15:02:46 2012)
X-Mailer: Balsa 2.4.11
Message-ID: <1352757066.32153.5@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 03:02:46 PM, Geert Uytterhoeven wrote:
> On Mon, Nov 12, 2012 at 9:58 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > JFYI, when comparing v3.7-rc5 to v3.7-rc4[3], the summaries are:
> >   - build errors: +14/-4
> 
> 14 regressions:
>   + drivers/virt/fsl_hypervisor.c: error: 'MSR_GS' undeclared (first
> use in this function):  => 799:93

These reports would be more useful if the actual .config were provided,  
rather than just saying "powerpc randconfig".

I doubt this particular one is a regression; it looks like the  
dependencies have always been too weak (patch sent) and you're just  
comparing different randomly-generated configs.

> powerpc-randconfig
> 
>   + error: relocation truncated to fit: R_PPC64_REL24 against symbol
> `._mcount' defined in .text section in arch/powerpc/kernel/entry_64.o:
> (.text+0x1ff9eb8) => (.text+0x1ffa274), (.text+0x1ff7840)
> 
> powerpc-allyesconfig

It's been over 3 years since powerpc-allyesconfig built (it's just too  
big for the relocation model the kernel uses) -- how is this a  
regression?

-Scott
