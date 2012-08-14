Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2HNLeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:34:24 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62471 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab2HNLeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:34:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120809185029.GC24328@opensource.wolfsonmicro.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<20120809185029.GC24328@opensource.wolfsonmicro.com>
Date: Tue, 14 Aug 2012 13:34:22 +0200
Message-ID: <CACRpkdZMyR3FXcoRHEAuoyx8B6+4sMuKjeRdg9+TD14XzqO7Yg@mail.gmail.com>
Subject: Re: [PATCH 00/22] mop500 related Audio reorganisation and fixups
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ola LILJA2 <ola.o.lilja@stericsson.com>, Ola Lilja <olalilja@yahoo.se>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 8:50 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> On Thu, Aug 09, 2012 at 04:47:26PM +0100, Lee Jones wrote:
>> Another fine instalment of Audio fixes and Device Tree enablement
>> surrounding the mop500 sound driver. Hopefully containing all of
>> the recommendations suggested by Mark Brown.
>
> Can we have some review of this from the ARM side please?  It's pretty
> big...

I looked over it, merged two patches to ux500 fixes and ACKed these
I understand. For the patches mainly dealing with ALSA SoC I get
confused so would prefer to have Ola Lilja comment on those once
he's available.

Yours,
Linus Walleij
