Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab2DJJAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 05:00:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57744 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab2DJJAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 05:00:02 -0400
Date: Tue, 10 Apr 2012 09:59:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: common clk: fix clk_register_fixed_rate() under memory pressure
Message-ID: <20120410085956.GA24465@sirena.org.uk>
References: <20120405084808.GA21060@glitch>
 <CAJOA=zNt7V_LNLAyXxJU2oS3vTEhvZ1JUWAx+hqQM1t=Whjr6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJOA=zNt7V_LNLAyXxJU2oS3vTEhvZ1JUWAx+hqQM1t=Whjr6w@mail.gmail.com>
X-Cookie: Power is poison.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 02:52:15PM -0700, Turquette, Mike wrote:

> Thanks for the patch Domenico.  I did a big cleanup of the
> registration code for all of the basic clock types and a fix for this
> has already been rolled in to that branch, so I won't be taking this
> patch.  I'll Cc you on the fixes when I send them to the list
> (probably tomorrow).

Would it be possible for you to keep a tree in -next?  There's been
several people sending patches like this which have been superceeded by
your work and this might help avoid such duplicated work.
