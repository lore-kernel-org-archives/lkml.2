Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2GQLQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 07:16:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46922 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2GQLQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 07:16:38 -0400
Date: Tue, 17 Jul 2012 12:16:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/8] regmap: Add the indexed cache support
Message-ID: <20120717111635.GA27595@sirena.org.uk>
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1314978375-11539-3-git-send-email-dp@opensource.wolfsonmicro.com>
 <4E613986.4040007@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E613986.4040007@metafoo.de>
X-Cookie: 1 + 1 = 3, for large values of 1.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 10:16:06PM +0200, Lars-Peter Clausen wrote:

> I have some patches for the rbtree register cache code, which reduce some of
> it's complexity and also implements the adjacent node merging and allows
> smaller holes in the rbnodes register block if the block is smaller then an
> rbnode. Currently these patches are based on the ASoC register cache code, but
> they should be easy to rework onto of the regmap register cache code.

Dimitris just reminded me about what you said here - do you still have
those patches floating around?  This would really useful and would
make some other optimistations like not cacheing default values much
easier.
