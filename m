Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab2CDVmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 16:42:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54663 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab2CDVmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 16:42:01 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Dave Jones" <davej@redhat.com>
References: <QW36V-vSgyB.A.YIG.i79UPB@chimera>
In-Reply-To: <QW36V-vSgyB.A.YIG.i79UPB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <mQVKgxJpvQC.A.7mG.w79UPB@chimera>
Subject: [Bug #42629] recvmsg sleeping from invalid context
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  4 Mar 2012 22:21:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 3.1 and 3.2.

The following bug entry is on the current list of known regressions
introduced between 3.1 and 3.2.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42629
Subject		: recvmsg sleeping from invalid context
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2012-01-13 18:24 (52 days old)
Message-ID	: <20120113182401.GA25885@redhat.com>
References	: http://marc.info/?l=linux-kernel&m=132647921304184&w=2


