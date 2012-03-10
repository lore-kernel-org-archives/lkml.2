Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944Ab2CJCtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 21:49:52 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:37820 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756170Ab2CJCtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 21:49:49 -0500
Date: Sat, 10 Mar 2012 02:49:46 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/6] Squashfs updates
Message-ID: <4f5ac14a.FFnxyJK9okG0d06+%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches are intended for the next merge window.
There's nothing terribly exciting here, code tidy-ups,
a small bug fix, and an additional mount time sanity check.

      Squashfs: update comment removing reference to zlib only
      Squashfs: remove redundant length initialisation in squashfs_readdir
      Squashfs: remove redundant length initialisation in squashfs_lookup
      Squashfs: get rid of obsolete definitions in header file
      Squashfs: fix f_pos check in get_dir_index_using_offset
      Squashfs: add mount time sanity check for block_size and block_log match

Phillip
