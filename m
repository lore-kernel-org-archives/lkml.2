Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab0ITPpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:45:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:48842 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab0ITPpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:45:34 -0400
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/3 RESEND] BDI handling fixes
Date: Mon, 20 Sep 2010 17:44:28 +0200
Message-Id: <1284997471-9850-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi,

  I resend this series because I've messed up Jens' address in the original
posting. Jens, would you please include these fixes in your tree? Thanks.
The series of these three patches fixes the warning in __mark_inode_dirty()
which happens when I do e.g. touch /dev/zero.

								Honza
