Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab1DFUR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:17:29 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:48024 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab1DFUR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:17:28 -0400
Subject: Re: [PATCH] rfkill: Regulator consumer driver for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>, Guiming Zhuo <gmzhuo@gmail.com>
In-Reply-To: <1302120922.4090.17.camel@jlt3.sipsolutions.net>
References: <1302081679-812-1-git-send-email-ospite@studenti.unina.it>
	 <20110406141131.GC2810@opensource.wolfsonmicro.com>
	 <1302099669.4090.1.camel@jlt3.sipsolutions.net>
	 <1302113542.22852.7.camel@x61.thuisdomein>
	 <20110406183837.GI11941@tuxdriver.com>
	 <1302120620.22852.22.camel@x61.thuisdomein>
	 <1302120922.4090.17.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 22:17:20 +0200
Message-ID: <1302121040.4090.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 22:15 +0200, Johannes Berg wrote:
> On Wed, 2011-04-06 at 22:10 +0200, Paul Bolle wrote:
> > On Wed, 2011-04-06 at 14:38 -0400, John W. Linville wrote:
> > > The syntax may seem strange,
> > 
> > It does!
> > 
> > > but basically it just says "don't let me by y if RFKILL is m"
> > 
> > ... but, besides that, I can be any value. So in effect it's shorthand
> > for
> > 	depends on RFKILL=y || RFKILL=m && m || RFKILL=n
> > 
> > (which actually looks equally strange). Is that correct?
> 
> I don't think it is, I believe that an expression like "RFKILL=y" has a
> bool type, and a tristate type value that depends on a bool type can
> still take the value m.

Err, which is of course perfectly fine since if RFKILL is built in this
can be any value, and in the RFKILL=m case you force it to m by making
it depend on m directly. So yes, you're right.

johannes

