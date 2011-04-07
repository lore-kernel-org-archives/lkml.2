Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab1DGKJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 06:09:52 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:43171 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab1DGKJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 06:09:51 -0400
Subject: Re: [PATCH] rfkill: Regulator consumer driver for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>, Guiming Zhuo <gmzhuo@gmail.com>
In-Reply-To: <1302170472.21251.9.camel@thorin>
References: <1302081679-812-1-git-send-email-ospite@studenti.unina.it>
	 <20110406141131.GC2810@opensource.wolfsonmicro.com>
	 <1302099669.4090.1.camel@jlt3.sipsolutions.net>
	 <1302113542.22852.7.camel@x61.thuisdomein>
	 <1302115597.4090.11.camel@jlt3.sipsolutions.net>
	 <1302170472.21251.9.camel@thorin>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 12:09:38 +0200
Message-ID: <1302170978.3779.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 12:01 +0200, Bernd Petrovitsch wrote:
> On Mit, 2011-04-06 at 20:46 +0200, Johannes Berg wrote: 
> > On Wed, 2011-04-06 at 20:12 +0200, Paul Bolle wrote:
> [...] 
> > > But doesn't
> > > 	depends on RFKILL || !RFKILL
> > > 
> > > always evaluate to true when running "make *config"? (Even if RFKILL is
> > > an unknown symbol when that expression is parsed!)
> > 
> > No, it will not, you're forgetting that these things are tristate.
> 
> Boolean operators for tristate logic isn't intuitive at all IMHO.

*shrug*. You're free to propose patches to the kconfig system to make it
more intuitive. :-)

johannes

