Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab2EMVNd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 17:13:33 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36159 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2EMVNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 17:13:32 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 13 May 2012 23:13:27 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux-kernel@vger.kernel.org
Subject: bugzilla.kernel.org administration: Tell users to report at
 mailinglists, not at the tracker
Message-ID: <20120513231327.2c28d3d2@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, whoever administers bugzilla.kernel.org:

Please change the text at the start page to say something along the
lines of:

    ---------------------------------------------------------------
    This is a kernel bug tracker.
    Do *not* report bugs here.
    Some bugs are /tracked/ here, but they are /not reported/ here.

    Please report bugs at the kernel mailinglists.  Thank you.

    Some tips:
    REPORTING-BUGS - http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=REPORTING-BUGS

    List addresses:
    MAINTAINERS - http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=MAINTAINERS
    (Almost all kernel mailinglists are open for postings without
    prior subscription.)
    ---------------------------------------------------------------

So, if you could please stop to mislead users into thinking that
they are welcome to open tickets at bugzilla.kernel.org, that would
be really helpful to everyone involved.

Thanks.
-- 
Stefan Richter
-=====-===-- -=-= -==-=
http://arcgraph.de/sr/
