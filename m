Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1DROBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:01:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43873 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab1DROBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:01:14 -0400
Date: Mon, 18 Apr 2011 15:01:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Tony Ibbs <tibs@tonyibbs.co.uk>, Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
Subject: Re: [PATCH] extra/1 Allow setting the maximum KBUS message size
Message-ID: <20110418140110.GD9462@sirena.org.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk> <20110322133640.5d5c88e4@bike.lwn.net> <DBA665CD-BE12-4DC8-9B3F-4170BED789BD@tonyibbs.co.uk> <32934D05-E7A7-4A2C-92EF-96A0580F2234@tonyibbs.co.uk> <20110415164608.489d82bf@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415164608.489d82bf@bike.lwn.net>
X-Cookie: APL hackers do it in the quad.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 04:46:08PM -0600, Jonathan Corbet wrote:

> That means getting more people to look at the patch, which could be hard.
> The problem is that, if you wait, they'll only squeal when the code is
> close to going in, and you could find yourself set back a long way.  A
> good first step might be to CC Andrew Morton on your next posting.

One other thing that it'd be good to see is a contrast and compare with
other similar things like the Android binder that are floating around.
