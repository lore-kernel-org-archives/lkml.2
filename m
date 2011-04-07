Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab1DGKRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 06:17:24 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:4585 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012Ab1DGKRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 06:17:22 -0400
X-Greylist: delayed 948 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Apr 2011 06:17:22 EDT
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host p37A1C4q005525
Subject: Re: [PATCH] rfkill: Regulator consumer driver for rfkill
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>, Guiming Zhuo <gmzhuo@gmail.com>
In-Reply-To: <1302115597.4090.11.camel@jlt3.sipsolutions.net>
References: <1302081679-812-1-git-send-email-ospite@studenti.unina.it>
	 <20110406141131.GC2810@opensource.wolfsonmicro.com>
	 <1302099669.4090.1.camel@jlt3.sipsolutions.net>
	 <1302113542.22852.7.camel@x61.thuisdomein>
	 <1302115597.4090.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 12:01:12 +0200
Message-ID: <1302170472.21251.9.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-DCC-STAT_FI_X86_64_VIRTUAL-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2011-04-06 at 20:46 +0200, Johannes Berg wrote: 
> On Wed, 2011-04-06 at 20:12 +0200, Paul Bolle wrote:
[...] 
> > But doesn't
> > 	depends on RFKILL || !RFKILL
> > 
> > always evaluate to true when running "make *config"? (Even if RFKILL is
> > an unknown symbol when that expression is parsed!)
> 
> No, it will not, you're forgetting that these things are tristate.

Boolean operators for tristate logic isn't intuitive at all IMHO.

Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

