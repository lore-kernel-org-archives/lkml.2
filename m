Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0FMPDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:03:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58822 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab0FMO5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 10:57:35 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Alex Shi" <alex.shi@intel.com>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <YPGdyfWGvNK.A.Y9.U8OFMB@chimera>
Subject: [Bug #15713] hackbench regression due to commit 9dfc6e68bfe6e
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Jun 2010 16:48:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15713
Subject		: hackbench regression due to commit 9dfc6e68bfe6e
Submitter	: Alex Shi <alex.shi@intel.com>
Date		: 2010-03-25 8:40 (81 days old)
First-Bad-Commit: http://git.kernel.org/linus/9dfc6e68bfe6ee452efb1a4e9ca26a9007f2b864
Message-ID	: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
References	: http://marc.info/?l=linux-kernel&m=126950632920682&w=4
Handled-By	: Christoph Lameter <cl@linux-foundation.org>
		  Pekka Enberg <penberg@cs.helsinki.fi>


