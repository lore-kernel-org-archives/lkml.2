Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab0LTMSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 07:18:47 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46759 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab0LTMSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 07:18:46 -0500
Date: Mon, 20 Dec 2010 12:18:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (mfd
	tree related)
Message-ID: <20101220121841.GB14986@sirena.org.uk>
References: <20101220192121.47767525.sfr@canb.auug.org.au> <20101220103336.GC11095@sortiz-mobl> <20101220105202.GA26706@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220105202.GA26706@rakim.wolfsonmicro.main>
X-Cookie: Always wear your seat belt.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 10:52:03AM +0000, Mark Brown wrote:
> On Mon, Dec 20, 2010 at 11:33:37AM +0100, Samuel Ortiz wrote:

> > Ok, I removed Mark's commit, the MFD tree should build fine now.
> > I'm keeping this one for whenever we'll have a proper pwm framework.

> It doesn't need dropping I think, the driver should just need a
> dependency on HAVE_PWM adding.

Meh, sorry, wrong way round.
