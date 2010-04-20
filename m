Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab0DTEB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 00:01:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48784 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab0DTEBP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 00:01:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Parag Warudkar" <parag.lkml@gmail.com>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
In-Reply-To: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <YeFfFNFyTSF.A.GdG.KRSzLB@tosh>
Subject: [Bug #15795] 2.6.34-rc4 : OOPS in unmap_vma
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 20 Apr 2010 05:19:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.33.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15795
Subject		: 2.6.34-rc4 : OOPS in unmap_vma
Submitter	: Parag Warudkar <parag.lkml@gmail.com>
Date		: 2010-04-14 (6 days old)
Message-ID	: <alpine.DEB.2.00.1004132147260.1881@parag-laptop>
References	: http://marc.info/?l=linux-kernel&m=127121006625429&w=2


