Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab0FTWaP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:30:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58679 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356Ab0FTWaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:30:10 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Christoph Lameter" <cl@linux-foundation.org>
References: <lc60d4toGTL.A.QzD._LpHMB@chimera>
In-Reply-To: <lc60d4toGTL.A.QzD._LpHMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <W8JfMs9cZw.A.U5D.FMpHMB@chimera>
Subject: [Bug #16255] 2.6.35-rc3 deadlocks on semaphore operations
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jun 2010 00:17:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16255
Subject		: 2.6.35-rc3 deadlocks on semaphore operations
Submitter	: Christoph Lameter <cl@linux-foundation.org>
Date		: 2010-06-18 14:49 (3 days old)
Message-ID	: <alpine.DEB.2.00.1006180940140.11575@router.home>
References	: http://marc.info/?l=linux-kernel&m=127687262727707&w=2


