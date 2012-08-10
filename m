Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab2HJLn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 07:43:59 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37496 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab2HJLn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 07:43:56 -0400
MIME-Version: 1.0
In-Reply-To: <003901cd7073$d49cacc0$7dd60640$@se>
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org>
	<1343741493-17671-3-git-send-email-lee.jones@linaro.org>
	<20120731134214.GK4468@opensource.wolfsonmicro.com>
	<5017EAC3.3080504@linaro.org>
	<20120731142820.GW4468@opensource.wolfsonmicro.com>
	<5017EDCA.4020601@linaro.org>
	<20120731145443.GY4468@opensource.wolfsonmicro.com>
	<5017F68B.3060400@linaro.org>
	<20120731151819.GC4468@opensource.wolfsonmicro.com>
	<5018D880.5090306@linaro.org>
	<20120801132022.GS11892@opensource.wolfsonmicro.com>
	<003901cd7073$d49cacc0$7dd60640$@se>
Date: Fri, 10 Aug 2012 13:43:56 +0200
Message-ID: <CACRpkdZeYAnqg7HLi_bH51_=s60OZB7ySn1W+YQ=H9fz8xZUCg@mail.gmail.com>
Subject: Re: [PATCH 1/6] ASoC: dapm: If one widget fails, do not force all
 subsequent widgets to fail too
From: Linus Walleij <linus.walleij@linaro.org>
To: Ola Lilja <olalilja@yahoo.se>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Philippe BEGNIC <philippe.begnic@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(As for the thread, which got flamy, let's put it to rest, and Ola:
 we are all impressed with your work on the ux500 ALSA SoC
 driver, no doubt about that, this was all ever about the DT
 patch set.)

On Thu, Aug 2, 2012 at 7:58 AM, Ola Lilja <olalilja@yahoo.se> wrote:

> Linus W. could probably shed some light of when the missing clocks are to
> be submitted.

Ulf Hansson is working on this but he's on vacation FTM.
However he has shown good progress and can probably present
a prototype clock driver when he arrives back. IIRC there was
some clock reparenting business left to sort out.

Yours,
Linus Walleij
