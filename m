Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab0GHX7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:59:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37922 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160Ab0GHX6y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:58:54 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Manfred Spraul" <manfred@colorfullife.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
In-Reply-To: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TXb9XdQzJoD.A.mgC.3MmNMB@chimera>
Subject: [Bug #16255] 2.6.35-rc3 deadlocks on semaphore operations
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  9 Jul 2010 01:41:36 +0200 (CEST)
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
Date		: 2010-06-18 14:49 (21 days old)
Message-ID	: <alpine.DEB.2.00.1006180940140.11575@router.home>
References	: http://marc.info/?l=linux-kernel&m=127687262727707&w=2
Handled-By	: Manfred Spraul <manfred@colorfullife.com>
Patch		: http://marc.info/?l=linux-kernel&m=127731055203402&w=2


