Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703Ab0EUWMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 18:12:10 -0400
Received: from xenotime.net ([72.52.115.56]:60077 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753078Ab0EUWMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 18:12:08 -0400
Date: Fri, 21 May 2010 15:12:03 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: piotr@hosowicz.com
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: What's up with wireless drivers?
Message-Id: <20100521151203.f94c1d3e.rdunlap@xenotime.net>
In-Reply-To: <4BF6FBB0.6060407@example.com>
References: <4BF6F2E4.5030800@example.com>
	<20100521210729.GC2495@tuxdriver.com>
	<4BF6F959.5040401@example.com>
	<4BF6FBB0.6060407@example.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 23:31:28 +0200 Piotr Hosowicz wrote:

> On 21.05.2010 23:21, Piotr Hosowicz wrote:
> > On 21.05.2010 23:07, John W. Linville wrote:
> >> On Fri, May 21, 2010 at 10:53:56PM +0200, Piotr Hosowicz wrote:
> >>> Hello,
> >>>
> >>> I try to build kernel from git source. Now n-th build try is
> >>> performing, each time it failed on wireless drivers - Atheros,
> >>> Marvel etc. Did I miss something?
> >>>
> >>> Regards,
> >>>
> >>> Piotr Hosowicz
> >>
> >> Perhaps you should post your actual output from the build failure?
> >
> > I dont have it right now, I disabled wireless at all and started build.
> > The output to the console was make-kpkg ordinary message - saying that
> > sub build finished with error code 2 AFAIR, it stopped each time on
> > wireless drivers.
> 
> Zonk! It seems that the problem is not only with wireless, now it broke 
> here:
> 
> (snip)
>    CC [M]  drivers/net/usb/int51x1.o
>    CC [M]  drivers/net/usb/cdc-phonet.o
>    CC [M]  drivers/net/wan/lmc/lmc_media.o
>    CC [M]  drivers/net/wan/lmc/lmc_main.o
>    CC [M]  drivers/net/wan/wanxl.o
>    CC [M]  drivers/net/usb/ipheth.o
>    LD [M]  drivers/net/wan/cyclomx.o
>    CC [M]  drivers/net/usb/sierra_net.o
>    CC [M]  drivers/net/wan/lmc/lmc_proto.o
>    LD [M]  drivers/net/wan/lmc/lmc.o
> make[1]: Opuszczenie katalogu `/usr/src/linus/linux-2.6-20100521-2044'
> make: *** [debian/stamp/build/kernel] Błąd 2
> 
> Opuszczenie katalogu `/usr/src/linus/linux-2.6-20100521-2044' is 
> "leaving directory", Błąd is error.

That still doesn't show the actual error/problem message...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
