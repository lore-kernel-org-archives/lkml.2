Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2G3Ppu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:45:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50018 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab2G3Ppt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:45:49 -0400
Date: Mon, 30 Jul 2012 16:45:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: sandeep@freescale.com, devel@driverdev.osuosl.org,
        linuxppc-dev@lists.ozlabs.org, galak@kernel.crashing.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [2/3][PATCH][v2] TDM Framework
Message-ID: <20120730154536.GA3218@sirena.org.uk>
References: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
 <20120727152542.GB1613@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120727152542.GB1613@electric-eye.fr.zoreil.com>
X-Cookie: The star of riches is shining upon you.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 05:25:42PM +0200, Francois Romieu wrote:

> 2. It would probably make sense to Cc: netdev and serial. There may be
>    some kernel client network integration from the start.

Plus audio, quite a few of the buses mentioned as examples of use cases
for the hardware are audio ones.
