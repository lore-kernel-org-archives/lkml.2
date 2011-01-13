Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab1AMN5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:57:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54858 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab1AMN5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:57:37 -0500
Subject: Re: [PATCH] ASoC: Blackfin TDM: fix missed snd_soc_dai_get_drvdata
 update
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mike Frysinger <vapier@gentoo.org>
Cc: alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        uclinux-dist-devel@blackfin.uclinux.org, stable@kernel.org,
        stable-review@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1294805299-5265-1-git-send-email-vapier@gentoo.org>
References: <1294805299-5265-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 13:57:32 +0000
Message-ID: <1294927052.3453.11.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-11 at 23:08 -0500, Mike Frysinger wrote:
> One spot was missed in this driver when converting from
> snd_soc_dai.private_data to snd_soc_dai_get_drvdata.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

