Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1FNSns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:43:48 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:6040 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab1FNSno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:43:44 -0400
Subject: Re: [GIT PULL] AVR32 update for 3.0
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: AVR32 Linux Kernel <kernel@avr32linux.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTi=rf1bhyL-xKtZfFM8-phZWA-8S0Q@mail.gmail.com>
References: <1308054796.16682.14.camel@hcegtvedt.norway.atmel.com>
	 <BANLkTi=rf1bhyL-xKtZfFM8-phZWA-8S0Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Tue, 14 Jun 2011 20:42:46 +0200
Message-ID: <1308076966.32705.6.camel@hcegtvedt.norway.atmel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2011 18:42:51.0146 (UTC) FILETIME=[DD48CEA0:01CC2AC2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 11:28 -0700, Linus Torvalds wrote:
> On Tue, Jun 14, 2011 at 5:33 AM, Hans-Christian Egtvedt
> <hans-christian.egtvedt@atmel.com> wrote:
> >
> >  arch/avr32/configs/atngw100_defconfig              |    1 -
> >  arch/avr32/configs/atngw100_evklcd100_defconfig    |    1 -
> >  arch/avr32/configs/atngw100_evklcd101_defconfig    |    1 -
> >  arch/avr32/configs/atngw100_mrmt_defconfig         |    1 -
> >  arch/avr32/configs/atngw100mkii_defconfig          |    1 -
> >  .../avr32/configs/atngw100mkii_evklcd100_defconfig |    1 -
> >  .../avr32/configs/atngw100mkii_evklcd101_defconfig |    1 -
> >  arch/avr32/configs/atstk1002_defconfig             |    1 -
> >  arch/avr32/configs/atstk1003_defconfig             |    1 -
> >  arch/avr32/configs/atstk1004_defconfig             |    1 -
> >  arch/avr32/configs/atstk1006_defconfig             |    1 -
> >  arch/avr32/configs/favr-32_defconfig               |    1 -
> >  arch/avr32/configs/hammerhead_defconfig            |    1 -
> >  arch/avr32/configs/merisc_defconfig                |    1 -
> >  arch/avr32/configs/mimc200_defconfig               |    1 -
> >  arch/avr32/include/asm/processor.h                 |    1 +
> >  arch/avr32/mach-at32ap/at32ap700x.c                |    3 +--
> >  arch/avr32/mach-at32ap/include/mach/cpu.h          |   12 ------------
> >  arch/avr32/mach-at32ap/intc.c                      |    4 +++-
> >  19 files changed, 5 insertions(+), 30 deletions(-)
> 
> How did you generate that pull request? I was all "Yay - code
> removal!", but then when actually pulling, noticed that your diffstat
> was exactly the wrong way around (the removals were adds, the adds
> were removals), and the real stats end up being
> 
>  19 files changed, 30 insertions(+), 5 deletions(-)
> 
> instead :(

Sorry, my bad, trusting my shells history. "master.." was swapped to
"..master". Since the volume for AVR32 related patches are so low, I do
stuff like this manually. Which now resulted in inverted statistics.

Correct diff stat is

 arch/avr32/configs/atngw100_defconfig              |    1 +
 arch/avr32/configs/atngw100_evklcd100_defconfig    |    1 +
 arch/avr32/configs/atngw100_evklcd101_defconfig    |    1 +
 arch/avr32/configs/atngw100_mrmt_defconfig         |    1 +
 arch/avr32/configs/atngw100mkii_defconfig          |    1 +
 .../avr32/configs/atngw100mkii_evklcd100_defconfig |    1 +
 .../avr32/configs/atngw100mkii_evklcd101_defconfig |    1 +
 arch/avr32/configs/atstk1002_defconfig             |    1 +
 arch/avr32/configs/atstk1003_defconfig             |    1 +
 arch/avr32/configs/atstk1004_defconfig             |    1 +
 arch/avr32/configs/atstk1006_defconfig             |    1 +
 arch/avr32/configs/favr-32_defconfig               |    1 +
 arch/avr32/configs/hammerhead_defconfig            |    1 +
 arch/avr32/configs/merisc_defconfig                |    1 +
 arch/avr32/configs/mimc200_defconfig               |    1 +
 arch/avr32/include/asm/processor.h                 |    1 -
 arch/avr32/mach-at32ap/at32ap700x.c                |    3 ++-
 arch/avr32/mach-at32ap/include/mach/cpu.h          |   12 ++++++++++++
 arch/avr32/mach-at32ap/intc.c                      |    4 +---
 19 files changed, 30 insertions(+), 5 deletions(-)

-- 
Hans-Christian Egtvedt

