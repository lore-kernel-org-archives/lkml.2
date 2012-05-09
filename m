Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761096Ab2EIUi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:38:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49701 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2EIUi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:38:26 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v9 00/19] Introduce a led trigger for CPU activity and consolidate LED driver in ARM
Date: Wed, 9 May 2012 20:38:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Bryan Wu <bryan.wu@canonical.com>, linux@arm.linux.org.uk,
        rpurdie@rpsys.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        nicolas.pitre@linaro.org, tim.gardner@canonical.com,
        Olof Johansson <olof@lixom.net>
References: <1335884506-15370-1-git-send-email-bryan.wu@canonical.com> <CAK5ve-KSyvZSHw7csQ5M88q0008NSrs1kwuyUH3hFqxD0f7BQQ@mail.gmail.com> <20120509122436.1b612004.akpm@linux-foundation.org>
In-Reply-To: <20120509122436.1b612004.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205092038.16722.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:OKfBd1uPZCEaS/jOVdAPuA9jXdAnyT81v+/2rIZhII+
 wR2wKaQZMZiLn0+47oK2hiYxFeM4/7brj3Mo+F1a5CTIdWKyQ5
 X+Mk6x3CYJDfZKBnSnxGT6lMN2Oi6jl0UVdw0Gl7HzRH9iSTnP
 uxZ77ITgAaSFeGj7JcXJ+wuoIOb1vFIDDtA4hdzoXPlfrkknl4
 uiz6U3ew4J7zX/EsUzYSbHCozNLRzH147ckCFzdVPTPtq9CVPd
 582x8RCYdX7eQuEnSIgdtuY2NBsHYG2cRFIsjoSM5QaH9ziROa
 fKhKgMdkdmtIOu/5OmKrrLZrFnRQDhJ+PHt1y7zKDAm+xhzgtD
 Jwm5RuQOzv4TI8SKnBF5IFYZGsF1Ep6XGU5K71hzX
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 May 2012, Andrew Morton wrote:
> I'm the LEDs patchmonkey at present.  I can merge the drivers/leds
> change if you like, but there doesn't seem much point in that unless
> all the other patches get merged.
> 
> So my preferred approach would be for the patch series to get merged
> via some ARM tree.

I'm fine with taking it through arm-soc if that helps. In the long run,
it would be nice to have a proper maintainer for this again after Richard
more or less stepped down from that position. Given that Bryan has shown
that he's persistent enough to get this patch series to v9, how about
making him the primary maintainer for the entire subsystem? He should
know a lot about it already. Bryan?

	Arnd
