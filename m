Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab1BCAHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:07:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38547 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451Ab1BCAHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:07:48 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Brett Witherspoon" <spoonb@exherbo.org>
References: <e9vOd5LzdBK.A.dyD.h6eSNB@chimera>
In-Reply-To: <e9vOd5LzdBK.A.dyD.h6eSNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <-tcJxClTQPH.A.DTE.N7eSNB@chimera>
Subject: [Bug #26942] radeon: screen distortion on resume
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  3 Feb 2011 01:05:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.36 and 2.6.37.

The following bug entry is on the current list of known regressions
introduced between 2.6.36 and 2.6.37.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=26942
Subject		: radeon: screen distortion on resume
Submitter	: Brett Witherspoon <spoonb@exherbo.org>
Date		: 2011-01-17 13:23 (17 days old)


