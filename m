Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab2BWXYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:24:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39852 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757371Ab2BWXXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:23:37 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Dave Jones" <davej@redhat.com>
References: <1qKPXd1RqtP.A.wjG.ShsRPB@chimera>
In-Reply-To: <1qKPXd1RqtP.A.wjG.ShsRPB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <JM4ZOHxb-FL.A.FCH.jhsRPB@chimera>
Subject: [Bug #42629] recvmsg sleeping from invalid context
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 24 Feb 2012 00:06:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 3.1 and 3.2.

The following bug entry is on the current list of known regressions
introduced between 3.1 and 3.2.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42629
Subject		: recvmsg sleeping from invalid context
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2012-01-13 18:24 (42 days old)
Message-ID	: <20120113182401.GA25885@redhat.com>
References	: http://marc.info/?l=linux-kernel&m=132647921304184&w=2


