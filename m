Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab2EPXvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 19:51:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:43353 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760766Ab2EPXvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 19:51:45 -0400
Message-ID: <1337212281.30558.17.camel@pasglop>
Subject: Re: Build regressions/improvements in v3.4-rc7
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Date: Thu, 17 May 2012 09:51:21 +1000
In-Reply-To: <CAMuHMdUtL4_mv-e-EQAZmNcb9dAT=PXB59i7Vuj2vf8NnaBFzQ@mail.gmail.com>
References: <1337157034-22773-1-git-send-email-geert@linux-m68k.org>
	 <CAMuHMdUtL4_mv-e-EQAZmNcb9dAT=PXB59i7Vuj2vf8NnaBFzQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 10:47 +0200, Geert Uytterhoeven wrote:
> On Wed, May 16, 2012 at 10:30 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > JFYI, when comparing v3.4-rc7 to v3.4-rc6[3], the summaries are:
> >  - build errors: +15/-14
> 
> 15 regressions:
>   + arch/powerpc/platforms/512x/mpc512x_shared.c: error: 'enum
> fsl_diu_monitor_port' declared inside parameter list [-Werror]:  =>
> 70:9, 84:9, 88:36
>   + arch/powerpc/platforms/512x/mpc512x_shared.c: error: 'return' with
> a value, in function returning void [-Werror]:  => 189:2
>   + arch/powerpc/platforms/512x/mpc512x_shared.c: error: function
> declaration isn't a prototype [-Werror=strict-prototypes]:  => 69:5,
> 88:6, 83:6, 187:1
>   + arch/powerpc/platforms/512x/mpc512x_shared.c: error: its scope is
> only this definition or declaration, which is probably not what you
> want [-Werror]:  => 70:9
>   + drivers/virt/fsl_hypervisor.c: error: 'MSR_GS' undeclared (first
> use in this function):  => 799:80
>
> powerpc randconfig
 
Thanks. These are all freescale platforms, the relevant people should be
already but I've added Scott and Kumar to the CC list just in case.

Cheers,
Ben.

