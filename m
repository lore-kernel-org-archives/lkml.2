Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab1CFMvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:51:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55995 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab1CFMvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:51:15 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Dave Chinner" <david@fromorbit.com>
References: <dtUMITvTCCN.A.uuF.y-3cNB@chimera>
In-Reply-To: <dtUMITvTCCN.A.uuF.y-3cNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sUKqYsqyJ4N.A.LuH.ID4cNB@chimera>
Subject: [Bug #22942] [2.6.37-rc1, OOM] virtblk: OOM in do_virtblk_request()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Mar 2011 13:40:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.36 and 2.6.37.

The following bug entry is on the current list of known regressions
introduced between 2.6.36 and 2.6.37.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22942
Subject		: [2.6.37-rc1, OOM] virtblk: OOM in do_virtblk_request()
Submitter	: Dave Chinner <david@fromorbit.com>
Date		: 2010-11-05 1:30 (122 days old)
Message-ID	: <20101105013003.GE13830@dastard>
References	: http://marc.info/?l=linux-kernel&m=128892062917641&w=2


