Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab1BONck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 08:32:40 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:33802 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1BONci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 08:32:38 -0500
Date: Tue, 15 Feb 2011 22:32:35 +0900
From: Norbert Preining <preining@logic.at>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Subject: Re: [Bug #27702] regression 2.6.37 -> 2.6.38-rc1: after suspend
	backlight cannot be adjusted
Message-ID: <20110215133235.GM19325@gamma.logic.tuwien.ac.at>
References: <NMZS1i37KEE.A.1eG.6_wVNB@chimera> <8H3lez1sawF.A.G2H.LBxVNB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8H3lez1sawF.A.G2H.LBxVNB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On So, 13 Feb 2011, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.37.  Please verify if it still should be listed and let the tracking team
> know (either way).

It is, added an entry to the bug report. Still not fixed in mainstream.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27702
> Subject		: regression 2.6.37 -> 2.6.38-rc1: after suspend backlight cannot be adjusted
> Submitter	: Norbert Preining <preining@logic.at>
> Date		: 2011-01-21 1:55 (23 days old)
> Message-ID	: <20110121015529.GD9796@gamma.logic.tuwien.ac.at>
> References	: http://marc.info/?l=linux-kernel&m=129557717826819&w=2
> Handled-By	: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
> Patch		: https://patchwork.kernel.org/patch/499221/

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
POLPERRO (n.)
A polperro is the ball, or muff, of soggy hair found clinging to bath
overflow-holes.
			--- Douglas Adams, The Meaning of Liff
