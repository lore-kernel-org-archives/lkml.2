Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab1DTLjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 07:39:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60210 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab1DTLjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 07:39:18 -0400
Subject: Re: [alsa-devel] [PATCH] ASoC: Add EQ and filter to max98095 CODEC
 driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Peter Hsiang <cdefgab1288@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Hsiang <peter.hsiang@maxim-ic.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Jesse Marroquin <jesse.marroquin@maxim-ic.com>
In-Reply-To: <1303262440-19412-1-git-send-email-peter.hsiang@maxim-ic.com>
References: <1303262440-19412-1-git-send-email-peter.hsiang@maxim-ic.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 12:39:13 +0100
Message-ID: <1303299553.3436.5.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 18:20 -0700, Peter Hsiang wrote:
> This patch adds the equalizer and biquad filter controls.
> 
> Signed-off-by: Peter Hsiang <peter.hsiang@maxim-ic.com>
> ---
>  include/sound/max98095.h    |   28 +++
>  sound/soc/codecs/max98095.c |  391 +++++++++++++++++++++++++++++++++++++++++++
>  sound/soc/codecs/max98095.h |   15 ++
>  3 files changed, 434 insertions(+), 0 deletions(-)
> 

Acked-by: Liam Girdwood <lrg@ti.com>

