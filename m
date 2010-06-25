Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab0FYLzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 07:55:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37750 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab0FYLza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 07:55:30 -0400
Date: Fri, 25 Jun 2010 12:55:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk
Message-ID: <20100625115528.GF2803@sirena.org.uk>
References: <1277387389-5103-1-git-send-email-marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277387389-5103-1-git-send-email-marek.vasut@gmail.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.240.126
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] tps65023: Allow registering similar TPS65021
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 03:49:49PM +0200, Marek Vasut wrote:
> TPS65021 is an older model and is slightly weaker (can supply less current),
> otherwise is the same.
> 
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
