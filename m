Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab1JNBlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 21:41:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59024 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1JNBle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 21:41:34 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1318556272.6379.4.camel@phoenix>
References: <1318556120.6379.1.camel@phoenix> <1318556272.6379.4.camel@phoenix>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 14 Oct 2011 09:41:13 +0800
Message-ID: <CAF+7xWkk0D_t0R5BsOBqbTY_GumwbEQNQO+KAri73zREicE+DA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ASoC: wm8991: Convert codec->hw_read to snd_soc_read
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/14 Axel Lin <axel.lin@gmail.com>:
> codec->hw_read is broken now, let's covert to snd_soc_read.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/wm8961.c |    4 +++-

Please ignore this one. the subject line is wrong.
The correct subject line is " [PATCH 3/3] ASoC: wm8961: Convert
codec->hw_read to snd_soc_read"

Axel
