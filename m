Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab1H2S1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:27:00 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41568 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab1H2S07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:26:59 -0400
Date: Mon, 29 Aug 2011 14:26:55 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Bryan Wu <bryan.wu@canonical.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Richard Purdie <rpurdie@rpsys.net>, arnd@arndb.de, tony@atomide.com,
        jochen@scram.de, linux-kernel@vger.kernel.org, jamie@jamieiles.com,
        linux@maxim.org.za, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 00/18] Introduce a led trigger for CPU activity and
 consolidate LED driver in ARM
In-Reply-To: <CAK5ve-+dEc8ie-pFp8e99rrqxAgWeiW3t30JO_sEBqd3BXeZkg@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1108291424310.20358@xanadu.home>
References: <1314349415-889-1-git-send-email-bryan.wu@canonical.com> <CACRpkda6-8dxSbF12N-Q32cOpogu-ZZmTApnvNBa03iOcEeqaQ@mail.gmail.com> <CAK5ve-JM=01vTqSi59R6ASyGU_2fVXzKtjNh42LKeF2HF3NzSA@mail.gmail.com> <20110829151333.GA17887@n2100.arm.linux.org.uk>
 <CAK5ve-+dEc8ie-pFp8e99rrqxAgWeiW3t30JO_sEBqd3BXeZkg@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011, Bryan Wu wrote:

> On Mon, Aug 29, 2011 at 11:13 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Mon, Aug 29, 2011 at 09:18:29PM +0800, Bryan Wu wrote:
> >> Yeah, I replied that email with a patch to select LEDS_CLASS when
> >> CONFIG_NEW_LEDS=y.
> >
> > I don't see any point to that:
> >
> 
> Actually, what I really want to propose is to kill this option and
> build in leds-class.c when CONFIG_NEW_LEDS=y, since most of functions
> of leds-class.c are widely used by others.
> 
> And you know, to select it as default is a simple workaround.

Please go ahead with complete solutions when they exist.  We don't want 
the mainline source tree filled with simple workarounds.


Nicolas
