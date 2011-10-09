Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab1JILGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 07:06:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33019 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab1JILGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 07:06:44 -0400
Date: Sun, 9 Oct 2011 12:06:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, lrg@ti.com
Subject: Re: [PATCH] tps65023-regulator: remove duplicate REG_CTRL2 defines
Message-ID: <20111009110642.GA1650@sirena.org.uk>
References: <201109191851.40743.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109191851.40743.hartleys@visionengravers.com>
X-Cookie: Made with real ingredients.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 06:51:39PM -0700, H Hartley Sweeten wrote:
> There are two sets of defines for the REG_CTRL2 bitfields and one
> of them has TPS65023_REG_CTRL2_DCDC1 defined incorrectly. Remove
> the duplicates and leave the correct one for TPS65023_REG_CTRL2_DCDC1.

Applied, thanks.

Please do try to use subject lines that correspond to those for the rest
of the subsystem, it makes applying the patches easier.
