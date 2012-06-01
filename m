Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394Ab2FAOsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:48:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52387 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933337Ab2FAOsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:48:31 -0400
Date: Fri, 1 Jun 2012 15:48:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
Cc: swarren@nvidia.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        olof@lixom.net
Subject: Re: [PATCH 0/9] Add clk_prepare/clk_unprepare
Message-ID: <20120601144825.GC15786@sirena.org.uk>
References: <1338541968-7961-1-git-send-email-pgaikwad@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338541968-7961-1-git-send-email-pgaikwad@nvidia.com>
X-Cookie: Here there be tygers.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 02:42:39PM +0530, Prashant Gaikwad wrote:
> This patch set adds use of clk_prepare/clk_unprepare as
> required by generic clock framework.

You should send these patches to the relevant subsystem maintainers.
