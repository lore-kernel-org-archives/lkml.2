Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab1DMRfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:35:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57876 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751409Ab1DMRft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:35:49 -0400
Date: Wed, 13 Apr 2011 10:36:00 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] ASoC: Make struct snd_soc_card's dapm_widgets and
 dapm_routes const
Message-ID: <20110413173559.GD18008@opensource.wolfsonmicro.com>
References: <1302629465-21315-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302629465-21315-1-git-send-email-lars@metafoo.de>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 07:31:01PM +0200, Lars-Peter Clausen wrote:
> Those should not be modified (and are not) by the core code, so make them const.
> This also makes them consistent with the same members of snd_soc_codec.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Applied 1, 3-5.
