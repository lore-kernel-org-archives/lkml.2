Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab2LMFIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 00:08:34 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:51973 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab2LMFId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 00:08:33 -0500
Date: Thu, 13 Dec 2012 05:08:33 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Paolo Pisati <paolo.pisati@canonical.com>
cc: linux-omap <linux-omap@vger.kernel.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: if voltage scaling fails, restore
 original
In-Reply-To: <alpine.DEB.2.00.1212130501260.25415@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.00.1212130507470.25415@utopia.booyaka.com>
References: <1355312753-16514-1-git-send-email-paolo.pisati@canonical.com> <alpine.DEB.2.00.1212130501260.25415@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="843723315-814718820-1355375313=:25415"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--843723315-814718820-1355375313=:25415
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 13 Dec 2012, Paul Walmsley wrote:

> Seems to me, na=EFvely, that in the above code, regulator->min_uV and=20
> regulator->max_uV should be set only after _regulator_do_set_voltage()=20
> succeeds?

Eh, never mind.  Looks like you took a similar strategy in the subsequent=
=20
patch you sent..


- Paul
--843723315-814718820-1355375313=:25415--
