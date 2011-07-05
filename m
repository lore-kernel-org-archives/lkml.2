Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab1GEU1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 16:27:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34190 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab1GEU1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 16:27:15 -0400
Date: Tue, 5 Jul 2011 21:27:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: lrg@ti.com, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH] ASoC: wm8731: set the ACTIVE bit if bias
	ON entered
Message-ID: <20110705202709.GA26404@sirena.org.uk>
References: <ccd4b125244271af7978948689cf1dcef37bc06b.1309368631.git.nicolas.ferre@atmel.com> <1309517034-26110-1-git-send-email-nicolas.ferre@atmel.com> <20110701161506.GC23784@opensource.wolfsonmicro.com> <4E118BF6.6010205@atmel.com> <20110704172856.GF28726@opensource.wolfsonmicro.com> <4E12C426.8050501@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E12C426.8050501@atmel.com>
X-Cookie: Man and wife make one fool.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 09:58:30AM +0200, Nicolas Ferre wrote:

> I have replaced this with ACTIVE to match the route declaration.

> *With this modification* it works, so you can add my:

> Tested-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Great, thanks.
