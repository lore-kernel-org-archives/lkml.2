Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab1FTUGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:06:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45881 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1FTUGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:06:44 -0400
Subject: Re: [PATCH] ASoC: codecs: Max98095: Fix logging of hardware
 revision.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Taylor Hutt <thutt@chromium.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Peter Hsiang <Peter.Hsiang@maxim-ic.com>,
        Olof Johansson <olofj@chromium.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1308596072-17158-1-git-send-email-thutt@chromium.org>
References: <1308596072-17158-1-git-send-email-thutt@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Jun 2011 21:06:29 +0100
Message-ID: <1308600389.2429.1.camel@CNA0741383>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-20 at 11:54 -0700, Taylor Hutt wrote:
> The base hardware revision of the Maxim 98095 part is 0x40; the code
> which outputs the revision of the hardware has been updated to
> properly use uppercase alphabetic values for the revision numbers.
> 
> Also, the use of a constant for the length 'max98095_dai' has been
> replaced with ARRAY_SIZE().
> 
> Signed-off-by: Taylor Hutt <thutt@chromium.org>

Acked-by: Liam Girdwood <lrg@ti.com>

