Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277Ab2FRM2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:28:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34676 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2FRM2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:28:40 -0400
Date: Mon, 18 Jun 2012 13:28:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH 00/12] irqdomain cleanup and refactoring
Message-ID: <20120618122839.GC5739@sirena.org.uk>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
X-Cookie: Whatever became of eternal truth?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 11:01:25PM -0600, Grant Likely wrote:

> - eliminate the legacy mapping by replacing it with a pre-populated linear map,

Can we also merge the registration functions (or add something like the
irq_domain_register_simple() patch I posted) while we're at it?  With
this code I *think* users still need to implement the boiler plate to
decided if they need linear or legacy mode.
