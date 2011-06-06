Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab1FFNFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:05:50 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49682 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752785Ab1FFNFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:05:49 -0400
Date: Mon, 6 Jun 2011 15:05:48 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>
Subject: Re: Disable CF during suspend
Message-ID: <20110606130548.GA4966@atrey.karlin.mff.cuni.cz>
References: <20110521094326.GB26323@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110521094326.GB26323@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> Disable SPITZ_SCP_CF_POWER during suspend. Otherwise it eats battery,
> fast. Thanks to Stanislav Brabec.
>     
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Works on the top of the 3.0-rc2 on my spitz.

Acked-by: Cyril Hrubis <metan@ucw.cz>

-- 
metan
