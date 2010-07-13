Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0GMXLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 19:11:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40196 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab0GMXLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 19:11:21 -0400
MIME-Version: 1.0
In-Reply-To: <20100713230352.6781.18644.stgit@angua>
References: <20100713230352.6781.18644.stgit@angua>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 13 Jul 2010 17:11:00 -0600
X-Google-Sender-Auth: eS27nX6nETS2DyusTysjGeplmJ0
Message-ID: <AANLkTilG016R6nnpy7COX4NZE6qWWO8ILvHAyyT4-bgV@mail.gmail.com>
Subject: Re: [RFC PATCH] Kconfig: Enable Kconfig fragments to be used for 
	defconfig
To: linuxppc-dev@lists.ozlabs.org, Nicolas Pitre <nico@fluxnic.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>, Daniel Walker <dwalker@codeaurora.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Typo correction:

2010/7/13 Grant Likely <grant.likely@secretlab.ca>:
[...]
> <board>.Kconfig defines new board specific config items (prefixed with
> "generateconfig_" which default to 'y' or 'm' and select the options
> that the platform cares about.  It also then either the architecture

s/either the/either includes the/

> default Kconfig, or another Kconfig fragment that includes the default
> one (therefore the fragments can be 'stacked' to include, say, default
> options for the architecture, or particular chipset).
[...]
