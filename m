Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1G0LHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 07:07:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55367 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab1G0LHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 07:07:45 -0400
Date: Wed, 27 Jul 2011 12:07:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] regulator: tps65023: Setting correct core
 regulator for tps65021
Message-ID: <20110727110740.GB300@sirena.org.uk>
References: <marcus.folkesson@gmail.com>
 <1311762767-20263-1-git-send-email-marcus.folkesson@gmail.com>
 <1311762767-20263-3-git-send-email-marcus.folkesson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311762767-20263-3-git-send-email-marcus.folkesson@gmail.com>
X-Cookie: If your bread is stale, make toast.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 12:32:46PM +0200, Marcus Folkesson wrote:
> TPS65023 is using VDCDC1 as core regulator and TPS65021 is using VDCDC3.

What is "core regulator" to the regulator chip itself?

> Core-regulator, voltage-tables and size of voltage-table may differ between
> different regulators. All those three is now passed as driver data.

No, the driver should be able to figure out for itself what regulators
are on the chip purely by knowing what chip it's talking to.  If there
is some configuration on the board from selection of passives or similar
the platform data should reflect how that's done (eg, supply the
relevant values for the passives).
