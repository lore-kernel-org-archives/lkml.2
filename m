Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab0KIRre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:47:34 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41309 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab0KIRrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:47:33 -0500
Date: Tue, 9 Nov 2010 17:47:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Jarkko Nikula <jhnikula@gmail.com>
Subject: Re: [PATCH] ASoC: Fix compile error if CONFIG_DEBUG_FS is not
	configured
Message-ID: <20101109174732.GB6961@sirena.org.uk>
References: <1289293604.28671.5.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289293604.28671.5.camel@mola>
X-Cookie: Beware the new TTY code!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 05:06:44PM +0800, Axel Lin wrote:
> Add soc_init_card_debugfs and soc_cleanup_card_debugfs functions to fix below error.
> 

Applied, thanks.
