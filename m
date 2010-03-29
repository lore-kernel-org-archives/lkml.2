Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab0C2GJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 02:09:35 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55998 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab0C2GJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 02:09:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=rL+lDfqKyzPS6OE6ZpMnlHUvS6nnpuK9M0DENM4KzS4/+eYGUHzUaRZPOHz9383nZ5
         E/S6Lk7k5v5GNDnDoZrNyqSkXngU93fyFdn2q5E0Ok/z9PVRmQNwYhRQrzS5aWhX1xLc
         vDYo6KaFEyvKfbmSTFnQ6o3SyPb0USWoPUKZs=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/6] blkdev: blkdev_issue_fn cleanups
Date: Mon, 29 Mar 2010 10:09:19 +0400
Message-Id: <1269842965-4700-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Convert all blkdev_issue_xxx function to common set of flags
- Optimize generic discard submitting procedure.
- Discard payload cleanup
Since introducing compat discard call was rejected by now.
This patch is contains only cleanups and one new library function
which later will be used instead of copy-pasted code-blocks in
different filesystem.

