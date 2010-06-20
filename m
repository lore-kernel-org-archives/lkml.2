Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab0FTW2l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:28:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58565 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524Ab0FTW21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:28:27 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Anton Vorontsov" <avorontsov@ru.mvista.com>,
       "Jeff Garzik" <jgarzik@redhat.com>, "Luming Yu" <luming.yu@gmail.com>
References: <lc60d4toGTL.A.QzD._LpHMB@chimera>
In-Reply-To: <lc60d4toGTL.A.QzD._LpHMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <W8JfMs9cZw.A.6TG.fNpHMB@chimera>
Subject: [Bug #16172] 2.6.25-rc1 ahci regression
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jun 2010 00:17:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16172
Subject		: 2.6.25-rc1 ahci regression
Submitter	: Luming Yu <luming.yu@gmail.com>
Date		: 2010-06-03 7:02 (18 days old)
First-Bad-Commit: http://git.kernel.org/linus/365cfa1ed5a36f9bcb9f64c9f0f52155af2e9fef
Message-ID	: <AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>>
References	: http://marc.info/?l=linux-kernel&m=127554855724361&w=2


