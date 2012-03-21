Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab2CUT4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:56:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53977 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab2CUT4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:56:39 -0400
Date: Wed, 21 Mar 2012 19:56:34 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: Constify parent name arrays
Message-ID: <20120321195633.GB27778@sirena.org.uk>
References: <1332357307-10693-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332357307-10693-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: Steal this tagline.  I did.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 07:15:07PM +0000, Mark Brown wrote:
> Drivers should be able to declare their arrays of parent names as const
> so the APIs need to accept const arguments.

Slight oversight in this one and the updates for the new API version
were simpler than I thought so sending a new version shortly.
