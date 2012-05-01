Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458Ab2EATIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 15:08:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758384Ab2EATIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 15:08:30 -0400
From: Doug Ledford <dledford@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, sfr@canb.auug.org.au
Subject: [Patch 0/4] ipc/mqueue improvements
Date: Tue,  1 May 2012 13:50:51 -0400
Message-Id: <1335894655-11398-1-git-send-email-dledford@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on the POSIX message queue subsystem a while back I
noticed some things that could stand to be improved (as it turns
out, drastically so).  So I improved them.  The first patch fixes
the POSIX message queue subsystem to not suck under heavy load and
high queue depths.  The next two are minor touchups/fixes.  The
fourth is in the tools/selftests directory and is the app I used
to do the performance testing of the mqueue subsystem.

Considering that the changes I've made here make as much as a
1000 fold difference in performance, it would be nice to see them
go into linux-next ;-)

Special note: these patches require and are built on top of my
previous patches.  Applying these to a tree that does not also
have the previous series of 7 patches I sent related to the
mqueue subsystem will result in a broken tree that won't compile.


--

  Doug Ledford <dledford@redhat.com>

