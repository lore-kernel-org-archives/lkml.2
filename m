Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab1C0Ut7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 16:49:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45826 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab1C0UqJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 16:46:09 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
References: <lDYNS4ATQ-N.A._aD.9m5jNB@chimera>
In-Reply-To: <lDYNS4ATQ-N.A._aD.9m5jNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <40UNry85rJN.A.BAF.6o5jNB@chimera>
Subject: [Bug #28842] 2.6.38-rc3 regression ipv6 TFTP download with curl failing in getpeername?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 27 Mar 2011 22:27:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.37.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28842
Subject		: 2.6.38-rc3 regression ipv6 TFTP download with curl failing in getpeername?
Submitter	: Eric W. Biederman <ebiederm@xmission.com>
Date		: 2011-02-08 9:41 (48 days old)
Message-ID	: <m1ei7iamnn.fsf@fess.ebiederm.org>
References	: http://marc.info/?l=linux-kernel&m=129715811421534&w=2


