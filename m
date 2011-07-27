Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab1G0LJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 07:09:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55385 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab1G0LJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 07:09:10 -0400
Date: Wed, 27 Jul 2011 12:09:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] regulator: tps65023: Fixes i2c configuration issues
Message-ID: <20110727110908.GC300@sirena.org.uk>
References: <marcus.folkesson@gmail.com>
 <1311762767-20263-1-git-send-email-marcus.folkesson@gmail.com>
 <1311762767-20263-2-git-send-email-marcus.folkesson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311762767-20263-2-git-send-email-marcus.folkesson@gmail.com>
X-Cookie: If your bread is stale, make toast.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 12:32:45PM +0200, Marcus Folkesson wrote:
> The original driver is missing the following:
> * Allow i2c core voltage adjustments by clearing CORE ADJ Allowed bit in CTRL2
> * Setting the GO bit in CTRL2 for updating the core voltage

These appear to be two separate changes and should rreally have been
split but

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
