Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240Ab2ERHrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 03:47:46 -0400
Received: from ozlabs.org ([203.10.76.45]:50041 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760123Ab2ERHrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 03:47:45 -0400
Message-ID: <1337327263.20191.6.camel@concordia>
Subject: Re: Re: Build regressions/improvements in v3.4-rc7
From: Michael Ellerman <michael@ellerman.id.au>
To: Timur Tabi <timur@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Scott Wood <scottwood@freescale.com>
Date: Fri, 18 May 2012 17:47:43 +1000
In-Reply-To: <4FB546A4.7090502@freescale.com>
References: <1337157034-22773-1-git-send-email-geert@linux-m68k.org>
	 <CAMuHMdUtL4_mv-e-EQAZmNcb9dAT=PXB59i7Vuj2vf8NnaBFzQ@mail.gmail.com>
	 <1337212281.30558.17.camel@pasglop> <4FB546A4.7090502@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 13:42 -0500, Timur Tabi wrote:
> Benjamin Herrenschmidt wrote:
> >   + arch/powerpc/platforms/512x/mpc512x_shared.c: error: 'enum
> >> fsl_diu_monitor_port' declared inside parameter list [-Werror]:  =>
> >> 70:9, 84:9, 88:36
> >>   + arch/powerpc/platforms/512x/mpc512x_shared.c: error: 'return' with
> >> a value, in function returning void [-Werror]:  => 189:2
> >>   + arch/powerpc/platforms/512x/mpc512x_shared.c: error: function
> >> declaration isn't a prototype [-Werror=strict-prototypes]:  => 69:5,
> >> 88:6, 83:6, 187:1
> >>   + arch/powerpc/platforms/512x/mpc512x_shared.c: error: its scope is
> >> only this definition or declaration, which is probably not what you
> >> want [-Werror]:  => 70:9
> 
> So I think I have a fix for these, but I still would like the actual
> .config so that I can be sure.

I believe it's this one:

http://kisskb.ellerman.id.au/kisskb/buildresult/6312867/config/


cheers



