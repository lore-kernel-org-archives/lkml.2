Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab2HJLd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 07:33:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64022 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab2HJLd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 07:33:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 06/11] gpio: em: do not discard em_gio_irq_domain_cleanup
Date: Fri, 10 Aug 2012 11:33:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Magnus Damm <damm@opensource.se>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de> <1344437248-20560-7-git-send-email-arnd@arndb.de> <CACRpkdZnaH3RXHqif7wiA5bor4vOcBndnabG-7QNLnmUc3Oj3Q@mail.gmail.com>
In-Reply-To: <CACRpkdZnaH3RXHqif7wiA5bor4vOcBndnabG-7QNLnmUc3Oj3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208101133.08945.arnd@arndb.de>
X-Provags-ID: V02:K0:qNRqkVsyFx2rRhw23chxkLHC23e9gLaQeuXk9Ksu3d1
 j+MXedz+JfbbbT69kcfIOE2Kjug+j2hb1sXybR//FUXtsizyEL
 czVkU3wPn/q4htfkEVQ+dkFfPWzPOUldJNbyy/OYhnk8EedwF4
 Ytp/Hd/OnefD14K9dBBSyZsZmqhjCNmZB14/cF6ul94zHoNy3b
 rAfjQh+7OxZ5E++t32iZSC9K4RrcMH90sOn0PVo8x7lT1c+jVQ
 UzMsMk9XfZeYluk0HvgAq1PlhkVpLD4U7o/3gTbBVeoNrpVs2C
 8m6aBSUZJvgy/WT1iJTNZRwsseBXPo1ZTyS+6fDHVT0eWEnOJs
 643VsIqQHc4M47AI6l9o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 August 2012, Linus Walleij wrote:
> On Wed, Aug 8, 2012 at 4:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > The newly added gpio-em driver marks its em_gio_irq_domain_cleanup
> > function as __devexit, which would lead to that function being
> > discarded in case CONFIG_HOTPLUG is disabled. However, the function
> > is also called by the error handling logic em_gio_probe, which
> > would cause a jump into a NULL pointer if it was removed from the
> > kernel or module.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Will you push this through the ARM SoC tree or do you want me
> to apply it to my GPIO tree?

I'm about to send out the whole series to Torvalds, so I'll just
keep it in now.

	Arnd
