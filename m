Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab2GJMLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 08:11:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab2GJMLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 08:11:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: a little dt pull request for 3.6
Date: Tue, 10 Jul 2012 12:08:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Prchal =?utf-8?q?Ji=C5=99=C3=AD?= <jiri.prchal@aksignal.cz>
References: <4FFB299D.7030902@atmel.com>
In-Reply-To: <4FFB299D.7030902@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207101208.35778.arnd@arndb.de>
X-Provags-ID: V02:K0:/FHhNgWV1x8DKbSprqKxLjAGWmINqo9aB5hwfKCULaC
 Ssr6JDs4F3aIMPouWVOOlVextknP93yuNnBkfZTMiUbE3fla/H
 +dj7HRB9YauwZDcLMFKvdaoNAzx0vjxcxMgOMRf2G1H8ArOeQ+
 Hb2W9Vdx3f12BPzLZXPzgpdsZbVM0Fx1/eoXT5O7mX1Xj6XT5q
 kxk+bAgynoXIS/LSkkqha+XKUsXWb5mnLJa4IZQwg+d4qtUSdH
 QCz/ZP2VixHv7qtdw38kFmIXZAgKLkF7uWYKGmMTbbu42Kap4b
 ZnO7+vdLOqWWCWB8wsQD6pw6n9s1cNvpxutH9dYQEk6RAcdL09
 tpRRGa2ofDiLIN0tyZPs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 July 2012, Nicolas Ferre wrote:
> Hi Arnd, hi Olof,
> 
> The following changes since commit bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a:
> 
>   Linux 3.5-rc6 (2012-07-07 17:23:56 -0700)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-for-next-dt
> 
> for you to fetch changes up to 3c68bb48214f87562b6956195178d991403d66d4:
> 
>   ARM: at91: Add support for board aks-cdu (2012-07-09 20:45:31 +0200)
> 
> ----------------------------------------------------------------
> Two new boards described with device tree
> 
> ----------------------------------------------------------------
> Fabio Porcedda (1):
>       ARM: at91: add support for Telit EVK-PRO3 with Telit GE863-PRO3
> 
> Jiri Prchal (1):
>       ARM: at91: Add support for board aks-cdu

Very nice!

Pulled into next/dt.

	Arnd
