Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab2IDQ2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:28:23 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49046 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409Ab2IDQ2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:28:22 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] Documentation/rbtree.txt changes
Date: Tue,  4 Sep 2012 17:28:07 +0100
Message-Id: <1346776090-4631-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some rbtree documentation fixes/changes.  After applying these changes,
the rb_entry() macro only gets a single mention in the document to say
it does the same thing as container_of().

1) Documentation/rbtree.txt: Fix possible typo in example
2) Documentation/rbtree.txt: Remove bogus description of rb_entry()
3) Documentation/rbtree.txt: Mention rb_entry()

 Documentation/rbtree.txt | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)
