Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379Ab0GWL4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:56:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51625 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425Ab0GWLvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:51:03 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Chris Wilson" <"email addresshidden"@ogre.sisk.pl>,
        "Eric Anholt" <"email addresshidden"@ogre.sisk.pl>,
        "Kees Cook" <kees@outflux.net>,
        "Tim Gardner" <tim.gardner@canonical.com>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
In-Reply-To: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <tneGvaw1wLL.A.9fB.v3XSMB@chimera>
Subject: [Bug #16294] [Q35 bisected] hang at init of i915 driver
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 23 Jul 2010 13:47:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16294
Subject		: [Q35 bisected] hang at init of i915 driver
Submitter	: Kees Cook <kees@outflux.net>
Date		: 2010-06-25 18:20 (29 days old)
First-Bad-Commit: http://git.kernel.org/linus/f1befe71fa7a79ab733011b045639d8d809924ad
Handled-By	: Tim Gardner <tim.gardner@canonical.com>
Patch		: https://patchwork.kernel.org/patch/111130/


