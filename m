Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab1JMSQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:16:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab1JMSQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:16:40 -0400
Date: Thu, 13 Oct 2011 20:16:37 +0200
From: Jan Kara <jack@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: New name of ext2/ext3/quota tree
Message-ID: <20111013181637.GC6018@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Stephen,

  since I had to recreate my tree at kernel.org, I've decided it's the
right time to switch from linux-fs-2.6 name to plain linux-fs. So could you
please pull
  pub/scm/linux/kernel/git/jack/linux-fs
instead of old
  pub/scm/linux/kernel/git/jack/linux-fs-2.6

  Thanks. Also, since changes to UDF are rather scarce, I've decided to
drop linux-udf-2.6 tree altogether and merge occasional UDF changes through
my linux-fs tree so you can drop that tree.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
