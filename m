Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab1CaMcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:32:41 -0400
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2772 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab1CaMck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:32:40 -0400
Date: Thu, 31 Mar 2011 14:32:27 +0000
From: Jurriaan <thunder8@xs4all.nl>
To: linux-kernel@vger.kernel.org
Subject: 2.6.38 crash (null pointer reference at
	mark_inode_dirty+0xa1/0x151)
Message-ID: <20110331143227.GA8238@onderneming10.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My laptop, running Debian Unstable + 2.6.38 debian kernel from
experimantal, just crashed.

unable to handle null reference pointer
mark_inode_dirty+0xa1/0x151

call trace (top lines)
setattr_copy
fat_setattr
path_init_rcu
need_resched

After resuming, I was adding backgrounds to Desktop Drapes and running
rsync from an ext4 partition to an USB stick with a vfat filesystem.

Kind regards,
Jurriaan
