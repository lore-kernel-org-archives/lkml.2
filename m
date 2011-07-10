Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab1GJLbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:31:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42631 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab1GJLZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:25:41 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "K.Prasad" <prasad@linux.vnet.ibm.com>
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera>
In-Reply-To: <AtAvQwe5sAK.A.loH.OlYGOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <gK_efVqs2fP.A.k7.hnYGOB@chimera>
Subject: [Bug #34942] [Bug] Kdump does not work when panic triggered due to MCE
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jul 2011 12:58:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.38 and 2.6.39.

The following bug entry is on the current list of known regressions
introduced between 2.6.38 and 2.6.39.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=34942
Subject		: [Bug] Kdump does not work when panic triggered due to MCE
Submitter	: K.Prasad <prasad@linux.vnet.ibm.com>
Date		: 2011-05-06 16:54 (66 days old)
Message-ID	: <20110506165412.GB2719@in.ibm.com>
References	: http://marc.info/?l=linux-kernel&m=130470087226270&w=2


