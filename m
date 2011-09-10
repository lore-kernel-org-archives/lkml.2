Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934087Ab1IJVKC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 17:10:02 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49209 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934050Ab1IJVKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 17:10:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: changes for next
Date: Sat, 10 Sep 2011 23:06:58 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Josef Holzmayr <holzmayr@rsi-elektrotechnik.de>,
        Nico Erfurth <ne@erfurth.eu>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
References: <4E6A09D0.40800@atmel.com>
In-Reply-To: <4E6A09D0.40800@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109102306.58340.arnd@arndb.de>
X-Provags-ID: V02:K0:03dJDuvwP7uCURypKHOXRAtFHNDUzVjCnhl6rEJiCHy
 xM8nF62U1LLLGXZ5Y7PNN8+fZsc+sVoi06RZ3JfWdZrnWomLQ5
 TyoTxCBcxlobw6dfeaJYfTl3bbTZ+OpnSfFFF1GwO43ZL+fDPe
 mq+p0MI/YBKa7HMwVpw/eYuqFvBCdSH7SnbGnIDwBjCJcbOdHt
 X/oZHgio5P3apwxstE5sj/90nogwqGccLn4hXG7FsLD48VrDsz
 OcBFXYox5W4u07P0QI1kOAFrmZVvE7S//jfcfM0nKo+Eig1p3Z
 +mb5+U3ki55VAixcxha/aqHXugDETLWrve1bA1rioVbgDlhNRo
 Cku3cDdJXeOE9GlUMAUw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 September 2011, Nicolas Ferre wrote:
> Can you please pull the following changes since commit ddf28352b80c86754a6424e3a61e8bdf9213b3c7:
> 
>   Linux 3.1-rc5 (2011-09-04 15:45:10 -0700)
> 
> They are available in the git repository at:
>   git://github.com/at91linux/linux-at91.git  at91-next
> 
> They have been present on linux-arm-kernel for some time and where recently added in linux-next.
> Stephen resolved some trivial conflicts relatives to the removal of a board file (Cf:
> https://lkml.org/lkml/2011/9/9/96 ).
> 
> A series by Thomas is touching the USB subsystem: ohci-at91.c but as most of changes are in the at91 directory, it makes more sense to take them in arm-soc.

Hi Nicolas,

I've resumed pulling patches and uploaded them to git.linaro.org while
master.kernel.org continues to be unavailable.

I've decided to split your branch into two separate branches 'board'
and 'devel' to better match the code from other soc trees in a way
that I can send forward to Linus. Please check that the split trees
actually make sense, and tell me if that's ok for you or if you would
prefer them split differently.

	Arnd
