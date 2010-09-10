Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab0IJS1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 14:27:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:50225 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab0IJS1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 14:27:32 -0400
Subject: Combined storage tree
From: James Bottomley <James.Bottomley@suse.de>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-ide <linux-ide@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 13:27:27 -0500
Message-ID: <1284143247.6551.23.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the requests from LSF10 in August was the production of a
combined storage tree.  This is now ready at

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/storage-tree

It's actually a nightly built merge tree consisting of

scsi-misc; scsi-rc-fixes
libata#upstream-fixes, libata#upstream
block#for-linus, block#for-next
and the dm quilt (which is empty at the moment).

I haven't yet added vfs or any of the fs trees, but if necessary, I can.

Note, because it's built nightly, like linux-next, it's hard (but not
impossible) to use it as a basis for git trees (it is much easier to use
it as a basis for quilts).

If there are any cross-tree patch sets, I can add them in for this too.

The trees are labelled <linux-tree>-stor<n>

You can find the combined diffs to the base linus tree here:

http://www.kernel.org/pub/linux/kernel/people/jejb/storage-tree

(The build script and driving file are in the parent directory).

Any build cockups or missing trees, please let me know.

James


