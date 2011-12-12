Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab1LLE35 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 23:29:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55913 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149Ab1LLE3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 23:29:55 -0500
Date: Mon, 12 Dec 2011 12:29:50 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 07/10] ASoC: OMAP: ams-delta: Drive modem/codec pins over
 GPIO API
Message-ID: <20111212042949.GA2806@opensource.wolfsonmicro.com>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <1323634328-856-8-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323634328-856-8-git-send-email-jkrzyszt@tis.icnet.pl>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 11, 2011 at 09:12:05PM +0100, Janusz Krzysztofik wrote:
> Don't use Amstrad Delta custom I/O functions any longer, replace them
> with GPIO. Old pin definitions, no longer used by the modem bits either,
> can be dropped.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
