Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab2EVJZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:25:35 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51997 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab2EVJZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:25:32 -0400
MIME-Version: 1.0
In-Reply-To: <1337585085-4891-1-git-send-email-corentin.chary@gmail.com>
References: <1337585085-4891-1-git-send-email-corentin.chary@gmail.com>
Date: Tue, 22 May 2012 10:25:31 +0100
Message-ID: <CAPM=9tzbMM09jENTZqDcnwEsA+G8y1A_orR8EgREePpxDzr0nQ@mail.gmail.com>
Subject: Re: [PATCH] backlight: initialize struct backlight_properties properly
From: Dave Airlie <airlied@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, Matthew Garrett <mjg@redhat.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Lars-Peter Clausen <lars@metafoo.de>, Axel Lin <axel.lin@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-fbdev@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 8:24 AM, Corentin Chary
<corentin.chary@gmail.com> wrote:
> In all these files, the .power field was never correctly initialized.
>
> Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
> ---
>  drivers/gpu/drm/i915/intel_panel.c              |    1 +
>  drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    1 +

I've taken these two hunks into drm-next.

Dave.
