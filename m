Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab2AGAyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 19:54:03 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38508 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759061Ab2AGAyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 19:54:01 -0500
Date: Sat, 7 Jan 2012 00:53:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Miguel Aguilar <miguel.aguilar@ridgerun.com>
Subject: Re: [PATCH v8 2/2] davinci: CQ93VC: remove machine specific header
 file inclusion from codec driver
Message-ID: <20120107005350.GA26307@sirena.org.uk>
References: <1325661469-4411-1-git-send-email-manjunath.hadli@ti.com>
 <1325661469-4411-3-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325661469-4411-3-git-send-email-manjunath.hadli@ti.com>
X-Cookie: No purchase necessary.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 12:47:49PM +0530, Manjunath Hadli wrote:
> remove unnecessary inclusion of machine specific header
> file mach/dm365.h from cq93vc.c voice codec driver
> which comes in the way of platform code consolidation.

*Always* CC maintainers on patches.  If you send me a copy directly this
looks OK.
