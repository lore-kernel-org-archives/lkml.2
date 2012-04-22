Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2DVVCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 17:02:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54940 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab2DVVCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 17:02:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: fist cleanup branch for 3.5
Date: Sun, 22 Apr 2012 20:32:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
References: <4F8D9037.9010401@atmel.com>
In-Reply-To: <4F8D9037.9010401@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204222032.48694.arnd@arndb.de>
X-Provags-ID: V02:K0:+idnx6QAI4xkjoX4tz+tO/HIERhYtQ9+IegRH4q69H8
 CHRI6Iy+njTP0Ktu+7FaHC9Fjf6fRlNbEXBAG1bx9H3AA/Ghqg
 tA1u8/7FRlB0pAiXF1yVw1njdPucDmGCK289yJoSA8UoWCEUPu
 by9ljtyGseuZr8O8MAFNEbGE9fAlrC66cgHw08yd3FCxtw5Ikh
 8qqFMsG/4PAcFxJ7vEdwXvcob0rtLGHZuMbfrvKRZr/z84i8d0
 hSErFAD8p1WuwtPJk+addnXhb2ksVBogoOLw4wFFUsy5Ce1yKa
 5iP3etxfVUTcpgtT53WZgG2l2/wXJgpySFD0CTGcrWvWSMj8hn
 nnSv9L9M3Y3Fs2emsK3o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2012, Nicolas Ferre wrote:
> Arnd, Olof,
> 
> The following changes since commit e816b57a337ea3b755de72bec38c10c864f23015:
> 
>   Linux 3.4-rc3 (2012-04-15 18:28:29 -0700)   
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-3.5-cleanup
> 
> for you to fetch changes up to 39ecc143b4c1f3d42e8300e7f5274681b99f95c2:
> 
>   ARM: at91: add defconfig for device tree (2012-04-17 14:47:22 +0200)
> 
> ----------------------------------------------------------------
> First batch of AT91 cleanup for 3.5 kernel.
> - The biggest improvement of this series is the ability to compile several
>   AT91 SoCs in one kernel image.
>   For now on it's limited to the DT-enabled boards but we can compile all
>   the core together.
> - The Kconfig series is stacked before other patches as it is simple and
>   non-intrusive. Its goal is to remove too restrictive dependencies on
>   SoC names. This will allow to add support for newer SoC seamlessly.
> - Some very "cosmetic" Kconfig changes are also added (entry names,
>   comments, etc.).

Pulled into the next/cleanup branch, and also pulled the MAINTAINERS
update into the next/maintainers branch.

Olof, this is the first pull from a tag I've done, and I think we
should decide on a method to show these pulls in the log. I've
set the at91/cleanup branch to the version that Nicolas sent,
without the merge changeset that is normally generated when you
pull from a tag. For next/cleanup branch, I've pulled directly from
the tag and edited the commit message a bit. Do you think that's good
or do you know a better way to handle these?

	Arnd

