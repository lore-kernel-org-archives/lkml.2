Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab1EPQ0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:26:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49678 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab1EPQ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:26:37 -0400
Subject: Re: [PATCH 7/9] ASoC: Silence DEBUG_STRICT_USER_COPY_CHECKS=y
 warning
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1305244212-19183-8-git-send-email-sboyd@codeaurora.org>
References: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org>
	 <1305244212-19183-8-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 17:26:32 +0100
Message-ID: <1305563192.3156.7.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 16:50 -0700, Stephen Boyd wrote:
> Enabling DEBUG_STRICT_USER_COPY_CHECKS causes the following
> warning:
> 
> In file included from arch/x86/include/asm/uaccess.h:573,
>                  from include/linux/poll.h:14,
>                  from include/sound/pcm.h:29,
>                  from include/sound/ac97_codec.h:31,
>                  from sound/soc/soc-core.c:34:
> In function 'copy_from_user',
>     inlined from 'codec_reg_write_file' at
>     sound/soc/soc-core.c:252:
> arch/x86/include/asm/uaccess_64.h:65:
> warning: call to 'copy_from_user_overflow' declared with
> attribute warning: copy_from_user() buffer size is not provably
> correct
> 
> presumably due to buf_size being signed causing GCC to fail to
> see that buf_size can't become negative.
> 
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Liam Girdwood <lrg@ti.com>

