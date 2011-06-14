Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1FNSaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:30:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101Ab1FNSaW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:30:22 -0400
MIME-Version: 1.0
In-Reply-To: <1308054796.16682.14.camel@hcegtvedt.norway.atmel.com>
References: <1308054796.16682.14.camel@hcegtvedt.norway.atmel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Jun 2011 11:28:20 -0700
Message-ID: <BANLkTi=rf1bhyL-xKtZfFM8-phZWA-8S0Q@mail.gmail.com>
Subject: Re: [GIT PULL] AVR32 update for 3.0
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: AVR32 Linux Kernel <kernel@avr32linux.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 5:33 AM, Hans-Christian Egtvedt
<hans-christian.egtvedt@atmel.com> wrote:
>
>  arch/avr32/configs/atngw100_defconfig              |    1 -
>  arch/avr32/configs/atngw100_evklcd100_defconfig    |    1 -
>  arch/avr32/configs/atngw100_evklcd101_defconfig    |    1 -
>  arch/avr32/configs/atngw100_mrmt_defconfig         |    1 -
>  arch/avr32/configs/atngw100mkii_defconfig          |    1 -
>  .../avr32/configs/atngw100mkii_evklcd100_defconfig |    1 -
>  .../avr32/configs/atngw100mkii_evklcd101_defconfig |    1 -
>  arch/avr32/configs/atstk1002_defconfig             |    1 -
>  arch/avr32/configs/atstk1003_defconfig             |    1 -
>  arch/avr32/configs/atstk1004_defconfig             |    1 -
>  arch/avr32/configs/atstk1006_defconfig             |    1 -
>  arch/avr32/configs/favr-32_defconfig               |    1 -
>  arch/avr32/configs/hammerhead_defconfig            |    1 -
>  arch/avr32/configs/merisc_defconfig                |    1 -
>  arch/avr32/configs/mimc200_defconfig               |    1 -
>  arch/avr32/include/asm/processor.h                 |    1 +
>  arch/avr32/mach-at32ap/at32ap700x.c                |    3 +--
>  arch/avr32/mach-at32ap/include/mach/cpu.h          |   12 ------------
>  arch/avr32/mach-at32ap/intc.c                      |    4 +++-
>  19 files changed, 5 insertions(+), 30 deletions(-)

How did you generate that pull request? I was all "Yay - code
removal!", but then when actually pulling, noticed that your diffstat
was exactly the wrong way around (the removals were adds, the adds
were removals), and the real stats end up being

 19 files changed, 30 insertions(+), 5 deletions(-)

instead :(

                    Linus
