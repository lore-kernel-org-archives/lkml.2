Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab0LAJu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:50:57 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51042 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab0LAJuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:50:55 -0500
Subject: Re: [alsa-devel] [PATCH] ASoC: Fix build failure in soc-core.c
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Jarkko Nikula <jhnikula@gmail.com>
Cc: alsa-devel@alsa-project.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
In-Reply-To: <1291187447-1247-1-git-send-email-jhnikula@gmail.com>
References: <20101201113138.f6146790.sfr@canb.auug.org.au>
	 <1291187447-1247-1-git-send-email-jhnikula@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 09:50:48 +0000
Message-ID: <1291197048.3292.2.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 09:10 +0200, Jarkko Nikula wrote:
> Commit 2eea392 "ASoC: Add support for optional auxiliary dailess codecs"
> causes a build failure in soc-core.c: soc_probe_aux_dev since code tries to
> access non-existing struct snd_soc_dapm_context and struct snd_soc_card
> members.
> 
> Root cause for this was a double accident. Author sent the RFC patch from
> top of another patch set and the RFC got committed. Fix the build failure
> by removing the code line that depends on that another patch set.
> 
> Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
> ---

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

