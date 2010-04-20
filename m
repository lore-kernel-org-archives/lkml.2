Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab0DTEDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 00:03:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48736 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab0DTEAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 00:00:31 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Heinz Diehl" <htd@fancy-poultry.org>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
In-Reply-To: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <YeFfFNFyTSF.A.zvH.wRSzLB@tosh>
Subject: [Bug #15711] 2.6.34-rc3, BUG at mm/slab.c:2989
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 20 Apr 2010 05:19:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.33.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15711
Subject		: 2.6.34-rc3, BUG at mm/slab.c:2989
Submitter	: Heinz Diehl <htd@fancy-poultry.org>
Date		: 2010-04-01 17:52 (19 days old)
Message-ID	: <20100401175225.GA6581@fancy-poultry.org>
References	: http://marc.info/?l=linux-kernel&m=127014437406250&w=2


