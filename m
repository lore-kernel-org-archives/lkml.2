Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab2EETuM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:50:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53840 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023Ab2EETuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:50:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 00/02] mach-shmobile: Emma Mobile EV2 - first shot
Date: Sat, 5 May 2012 19:50:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-arm-kernel@lists.infradead.org,
        horms@verge.net.au, linux@arm.linux.org.uk, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, lethal@linux-sh.org, olof@lixom.net
References: <20120503144645.6390.62303.sendpatchset@w520> <201205051921.13209.arnd@arndb.de> <201205052130.21081.rjw@sisk.pl>
In-Reply-To: <201205052130.21081.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205051950.01887.arnd@arndb.de>
X-Provags-ID: V02:K0:4FSce1Sc36oCqNkshBOIi+V4oyZsL0X3tYZPMeH71x7
 VpFt0ZGwbl3mmE38BBXrLdEtXWHoHADPDciv+NxXD1ZVAzHWCT
 rHvRK4Asl/R+LIZnTdbxWG8sdM1WSSKqsDdADH1YiDKCNgSwd3
 pW7xEV2eoK6i35FxRn1YA6qh6+pF2rfJvIN8Aot7m8vTileKxH
 H1vp6nwKAdKWf+XbmrhDy+jSVAp10UchurF2brL7LScPLQ/tKv
 EhTC4hbczabePEx8d0Xh18IcuEN3/EEdgNT4MzSpUuO5SMDy7Z
 VNJKsvcse5G/M1bbH+kDWYMUMmKlnZJUK5KApxFivu0ZSIW/GO
 /IhqPBMq7L2jgS9Jk4Rc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 May 2012, Rafael J. Wysocki wrote:
> > All the chips in there so far share a common ancestry and they all use a
> > significant subset of the same drivers shared with arch/sh: i2c-sh_mobile,
> > sh-dma-engine, sh_cmt, sh-sci, sh_tmu, intc, pfc and sh_clk. AFAICT, this one
> > uses none of those and apparently was developed by NEC before the merger with
> > Renesas.
> 
> I see.  So your opinion is that it may have more in common with the other
> ARM-based platforms?

Not with any one in particular, although there are a lot of similarities between
recent Cortex-A9 based designs. I just think it would be more logical to put the
files into a new mach-emma directory in the same way that every other family has
its own directory.

As I said, I don't mind if you share infrastructure with mach-shmobile, like
using the same mach/*.h header files, but if you end up sharing actual code,
it would be nicer to put it into some location where it can also be shared by
other platforms.

	Arnd
