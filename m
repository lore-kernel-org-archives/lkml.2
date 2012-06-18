Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab2FRMXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:23:51 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44950 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab2FRMXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:23:49 -0400
Date: Mon, 18 Jun 2012 13:23:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 08/12] irqdomain: Replace LEGACY mapping with LINEAR
Message-ID: <20120618122344.GB5739@sirena.org.uk>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
 <1339822897-15840-9-git-send-email-grant.likely@secretlab.ca>
 <1339826500.9220.224.camel@pasglop>
 <CACxGe6v_nz5pw8xjcy2-ewcZehY_KO0tgRO7=DtWOJS-e5uXMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6v_nz5pw8xjcy2-ewcZehY_KO0tgRO7=DtWOJS-e5uXMg@mail.gmail.com>
X-Cookie: Whatever became of eternal truth?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 12:16:32AM -0600, Grant Likely wrote:

> The functionality is still entirely there; it's just implemented with
> a linear map that gets populated with mappings to reserved irqs.
> Everything *should* keep working correctly.

I didn't see anywhere in the series where a user was updated to use this
mechanism - it might help make it clear what's going on if there was
sample code.  Since I added irqdomain support to some of my drivers I've
had several people say things like "Oh, that's actually really simple
now I see how to use it", this might be an example of that sort of
issue.
