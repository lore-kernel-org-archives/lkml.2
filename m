Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab0KVLmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 06:42:50 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51484 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab0KVLmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 06:42:49 -0500
Date: Mon, 22 Nov 2010 11:42:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: alsa-devel@alsa-project.org, Philipp Zabel <philipp.zabel@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Harald Welte <laforge@gnumonks.org>, lrg@slimlogic.co.uk
Subject: Re: [PATCH 2/3] ASoC: add iPAQ hx4700 machine driver
Message-ID: <20101122114247.GB15156@sirena.org.uk>
References: <1290257964-17435-1-git-send-email-mad_soft@inbox.ru> <1290257964-17435-3-git-send-email-mad_soft@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290257964-17435-3-git-send-email-mad_soft@inbox.ru>
X-Cookie: knowledge, n.:
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 03:59:23PM +0300, Dmitry Artamonow wrote:
> AK4641 connected via I2S and I2C, jack detection via GPIO.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>

This looks OK but depends on the CODEC driver.
