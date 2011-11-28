Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1K1Q6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:58:53 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51097 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1K1Q6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:58:52 -0500
MIME-Version: 1.0
In-Reply-To: <s5hipm4tlhw.wl%tiwai@suse.de>
References: <s5hipm4tlhw.wl%tiwai@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 28 Nov 2011 08:58:30 -0800
X-Google-Sender-Auth: LF49ywFIVDTSmpaNp2t2lVLyKzU
Message-ID: <CA+55aFyp7e1tDfGnJ57q=fVWq2JSNU9LrFBZZ1-iSXEM45Bg=w@mail.gmail.com>
Subject: Re: [GIT PULL] sound updates for 3.2-rc4
To: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 5:38 AM, Takashi Iwai <tiwai@suse.de> wrote:
>
> This includes a few trivial fixes for ASoC, an sta32x coef setup fix,
> and a few HD-audio fixes (including the fix for MacBook Air).

Btw, that one seems to have a bug, just looking at the patch:

 static const char * const cs420x_models[CS420X_MODELS] = {
 	[CS420X_MBP53] = "mbp53",
 	[CS420X_MBP55] = "mbp55",
 	[CS420X_IMAC27] = "imac27",
+	[CS420X_IMAC27] = "apple",
 	[CS420X_AUTO] = "auto",
 };

Spot the error?

                       Linus
