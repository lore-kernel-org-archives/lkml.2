Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976Ab0DHXmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 19:42:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41752 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759196Ab0DHXmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 19:42:37 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>,
       "Zhenyu Wang" <zhenyuw@linux.intel.com>
References: <cjwJ7Pf9h0L.A.9pB.1DmvLB@chimera>
In-Reply-To: <cjwJ7Pf9h0L.A.9pB.1DmvLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <onZ81XwyNTD.A.eyB.8DmvLB@chimera>
Subject: [Bug #15733] Crash when accessing nonexistent GTT entries in i915
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  9 Apr 2010 01:04:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.32 and 2.6.33.

The following bug entry is on the current list of known regressions
introduced between 2.6.32 and 2.6.33.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15733
Subject		: Crash when accessing nonexistent GTT entries in i915
Submitter	: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date		: 2010-03-10 22:09 (30 days old)
Message-ID	: <1268258994.2183.14.camel@carter>
References	: http://marc.info/?l=linux-kernel&m=126825901326111&w=4
Handled-By	: Zhenyu Wang <zhenyuw@linux.intel.com>
		  Andrew Morton <akpm@linux-foundation.org>


