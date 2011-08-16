Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab1HPP4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 11:56:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60401 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751236Ab1HPP4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 11:56:13 -0400
Date: Wed, 17 Aug 2011 00:56:07 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 4/4] Blackfin: bf537: Stamp: Register ASoC EVAL-ADAU1373
 board driver
Message-ID: <20110816155606.GG15484@opensource.wolfsonmicro.com>
References: <1313432124-22591-1-git-send-email-lars@metafoo.de>
 <1313432124-22591-4-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313432124-22591-4-git-send-email-lars@metafoo.de>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 08:15:24PM +0200, Lars-Peter Clausen wrote:
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Mike Frysinger <vapier@gentoo.org>

I'm OK with this but may as well go via the blackfin tree as there's no
code dependency on any of the ASoC stuff and it reduces the risk of any
collisions with other blackfin work.  If you guys would prefer that it
goes via ASoC then I can apply it there though.
