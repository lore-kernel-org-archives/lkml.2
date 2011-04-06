Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab1DFUKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:10:23 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:40794 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab1DFUKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:10:22 -0400
Subject: Re: [PATCH] rfkill: Regulator consumer driver for rfkill
From: Paul Bolle <pebolle@tiscali.nl>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>, Guiming Zhuo <gmzhuo@gmail.com>
In-Reply-To: <20110406183837.GI11941@tuxdriver.com>
References: <1302081679-812-1-git-send-email-ospite@studenti.unina.it>
	 <20110406141131.GC2810@opensource.wolfsonmicro.com>
	 <1302099669.4090.1.camel@jlt3.sipsolutions.net>
	 <1302113542.22852.7.camel@x61.thuisdomein>
	 <20110406183837.GI11941@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 22:10:19 +0200
Message-ID: <1302120620.22852.22.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 14:38 -0400, John W. Linville wrote:
> The syntax may seem strange,

It does!

> but basically it just says "don't let me by y if RFKILL is m"

... but, besides that, I can be any value. So in effect it's shorthand
for
	depends on RFKILL=y || RFKILL=m && m || RFKILL=n

(which actually looks equally strange). Is that correct?

Anyhow, perhaps this should be added to the "Kconfig hints" in
Documentation/kbuild/kconfig-language.txt.


Paul Bolle

