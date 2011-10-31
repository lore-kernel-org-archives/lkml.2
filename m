Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab1JaVjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:39:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33206 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab1JaVjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:39:07 -0400
Date: Mon, 31 Oct 2011 21:38:59 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: jhbird.choi@samsung.com, lrg@ti.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20111031213859.GA22025@sirena.org.uk>
References: <1319617556-29021-1-git-send-email-jhbird.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319617556-29021-1-git-send-email-jhbird.choi@samsung.com>
X-Cookie: Vini, vidi, Linux!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.41.29.181
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Use regmap_read/write(), regmap_update_bits
 functions directly
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 05:25:56PM +0900, jhbird.choi@samsung.com wrote:
> From: Jonghwan Choi <jhbird.choi@samsung.com>
> 
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>

Please make sure you CC Liam on all regulator API patches - you should
CC all the maintainers for the subsystem.  This needs to be refreshed
against current -next, it won't apply as-is (I suspect the patch is for
3.0 rather than current code).
