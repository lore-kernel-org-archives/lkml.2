Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2F1Re7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:34:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704Ab2F1Re6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:34:58 -0400
Date: Thu, 28 Jun 2012 19:34:55 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Timo Warns <warns@pre-sense.de>
Subject: [PULL REQUEST] UDF fixes for 3.5
Message-ID: <20120628173455.GA12939@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

  to get fixes making UDF more robust in presence of corrupted filesystem.
Top of the tree is 1df2ae3. The full shortlog is:

Jan Kara (3):
      udf: Use 'ret' instead of abusing 'i' in udf_load_logicalvol()
      udf: Avoid run away loop when partition table length is corrupted
      udf: Fortify loading of sparing table

The diffstat is

 fs/udf/super.c |  102 +++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 64 insertions(+), 38 deletions(-)

							Thanks
								Honza
