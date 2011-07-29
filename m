Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab1G2MdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:33:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47328 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab1G2MdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:33:13 -0400
Date: Fri, 29 Jul 2011 13:33:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] regulator: tps65023: Setting correct core
 regulator for tps65021
Message-ID: <20110729123309.GA22042@sirena.org.uk>
References: <marcus.folkesson@gmail.com>
 <1311762767-20263-1-git-send-email-marcus.folkesson@gmail.com>
 <1311762767-20263-3-git-send-email-marcus.folkesson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311762767-20263-3-git-send-email-marcus.folkesson@gmail.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 12:32:46PM +0200, Marcus Folkesson wrote:
> TPS65023 is using VDCDC1 as core regulator and TPS65021 is using VDCDC3.
> Core-regulator, voltage-tables and size of voltage-table may differ between
> different regulators. All those three is now passed as driver data.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
