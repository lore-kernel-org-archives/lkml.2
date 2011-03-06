Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab1CFM4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:56:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56039 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab1CFMv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:51:58 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Prasad Joshi" <prasadjoshi124@gmail.com>
References: <dtUMITvTCCN.A.uuF.y-3cNB@chimera>
In-Reply-To: <dtUMITvTCCN.A.uuF.y-3cNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sUKqYsqyJ4N.A.x_G.oA4cNB@chimera>
Subject: [Bug #26112] [LogFS] [2.6.37-rc8+] Kernel BUG at logfs/readwrite.c:297!
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Mar 2011 13:40:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.36 and 2.6.37.

The following bug entry is on the current list of known regressions
introduced between 2.6.36 and 2.6.37.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=26112
Subject		: [LogFS] [2.6.37-rc8+] Kernel BUG at logfs/readwrite.c:297!
Submitter	: Prasad Joshi <prasadjoshi124@gmail.com>
Date		: 2011-01-02 21:22 (64 days old)
Message-ID	: <AANLkTinpoM8FuG8UkF88xs_V37dz_wgE8t-s0JPzaS-w@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129400335910652&w=2


