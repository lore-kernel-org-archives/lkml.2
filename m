Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab0FBMT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:19:58 -0400
Received: from crca.org.au ([74.207.252.120]:44685 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753Ab0FBMT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:19:57 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Nigel's current for-rafael queue
Date: Wed,  2 Jun 2010 22:18:59 +1000
Message-Id: <1275481160-31150-1-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

Here is my current patch queue.

Taken together, the patches implement the separation of low level
block i/o into a separate file, switch from using swap_map_pages
to extents stores prior to the 'header' page and implement fully
asynchronous (rather than batched I/O). I have only run it under
VMware so far, but would estimate a doubling in speed due to the
async i/o.

Looking at Jiri's patches, there is definitely some overlap, but
more in terms of lines in the code than direction of effort (with
the exception of separating swap out). He has covered areas for
improvement that I was going to do, just not yet.

Jiri, unless you object, I'm going to seek to apply your patches
on top of what I've done. Does that sound okay?

Nigel

