Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab2JEHuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 03:50:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54669 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2JEHuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 03:50:06 -0400
Message-ID: <1349423405.3427.3.camel@coredoba.hi.pengutronix.de>
Subject: Re: [PATCH] mtd: m25p80: Add support for Numonyx N25Q128
From: Jan =?ISO-8859-1?Q?L=FCbbe?= <jlu@pengutronix.de>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Wendy Liang <wendy.liang@petalogix.com>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>
Date: Fri, 05 Oct 2012 09:50:05 +0200
In-Reply-To: <1349372416-16925-1-git-send-email-monstr@monstr.eu>
References: <1349372416-16925-1-git-send-email-monstr@monstr.eu>
Organization: Pengutronix
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:99ff:fe56:8d7
X-SA-Exim-Mail-From: jlu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 19:40 +0200, Michal Simek wrote:
> From: Wendy Liang <wendy.liang@petalogix.com>
> 
> Add the id and sector mappings for SPI flash chips.

An equivalent patch is already in David Woodhouse's l2-mtd tree:
http://git.infradead.org/users/dedekind/l2-mtd.git/commitdiff/3105875f6b8902628caee2fd7821af43707c6bde

Regards,
Jan
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

