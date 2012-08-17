Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab2HQWZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 18:25:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757158Ab2HQWZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 18:25:32 -0400
Message-ID: <1345242330.3841.8.camel@fedora64.linuxtx.org>
Subject: 3.5.x boot hang after conflicting fb hw usage <driver> vs VESA VGA
 - removing generic driver
From: "Justin M. Forbes" <jforbes@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@fedoraproject.org
Date: Fri, 17 Aug 2012 17:25:30 -0500
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for <driver>, we have verified cases on inteldrmfb, radeondrmfb, and
cirrusdrmfb.

This is the last message displayed before the system hangs.  This seems
to be hitting a large number of users in Fedora, though certainly not
everyone.  This started happening with the 3.5 updates, and is still an
issue.  It appears to be a race condition, because various things have
allowed boot to continue for some users, though there is no clear work
around. Has anyone else run across this?  Any ideas.  For more
background we have the following bugs:

inteldrmfb:
https://bugzilla.redhat.com/show_bug.cgi?id=843826

radeondrmfb:
https://bugzilla.redhat.com/show_bug.cgi?id=845745

cirrusdrmfb <kvm>:
https://bugzilla.redhat.com/show_bug.cgi?id=843860

It should be noted that the conflicting fb hw usage message is not new,
it has been around for a while, but this is the last message seen before
the hang.

Thanks,
Justin

