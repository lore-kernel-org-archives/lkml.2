Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab1LVLKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 06:10:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51582 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755176Ab1LVLKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 06:10:37 -0500
Date: Thu, 22 Dec 2011 11:10:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>, Liam Girdwood <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v2 1/7 v2] ARM: OMAP1: ams-delta: register latch
 dependent devices later
Message-ID: <20111222111032.GK4546@opensource.wolfsonmicro.com>
References: <201112200028.32947.jkrzyszt@tis.icnet.pl>
 <201112212051.13113.jkrzyszt@tis.icnet.pl>
 <20111221200728.GG24444@atomide.com>
 <201112221139.16317.jkrzyszt@tis.icnet.pl>
 <4EF30F9C.7030708@bitmer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF30F9C.7030708@bitmer.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 01:08:12PM +0200, Jarkko Nikula wrote:
> On 12/22/2011 12:39 PM, Janusz Krzysztofik wrote:

Guys *please* delete irrelevant context from mails.  I wasn't reading
any of the rest of it since nothing about the subject line says anything
about anything relevant and there was no content anywhere near the start
of the actual mails.  I only saw this because Jarkko did trim the
context.

> >Jarkko, Mark or Liam, care to ack this change, moving the Amstrad Delta
> >sound card registration to late_initcall?

> Unfortunately I haven't had time to look at the series but I'm fine
> with sound/soc/omap/ams-delta.c change.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
