Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560Ab1KVLvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:51:48 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42121 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab1KVLvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:51:47 -0500
Date: Tue, 22 Nov 2011 11:51:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] regmap: Fix build failure with CONFIG_DEBUG_FS=n
Message-ID: <20111122115145.GA6624@sirena.org.uk>
References: <1321950260-22193-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321950260-22193-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Cookie: "Elvis is my copilot."
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 09:24:20AM +0100, Uwe Kleine-K??nig wrote:
> This fixes:

Thanks for the report - I'm going to apply a different fix to cut down
the ifdefs.
