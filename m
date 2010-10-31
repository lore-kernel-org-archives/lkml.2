Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab0JaR2c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 13:28:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57412 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab0JaR2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 13:28:30 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 31 Oct 2010 18:28:12 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ext4_lazyinit_thread: 'ret' may be used uninitialized in this
 function
To: Lukas Czerner <lczerner@redhat.com>
cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>
Message-ID: <tkrat.ba371a0ea018042b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit bfff68738f1c "ext4: add support for lazy inode table
initialization" added the following build warning:

fs/ext4/super.c: In function 'ext4_lazyinit_thread':
fs/ext4/super.c:2702: warning: 'ret' may be used uninitialized in this function

This warning is due to an actual bug.  But I don't know what the fix is.
-- 
Stefan Richter
-=====-==-=- =-=- =====
http://arcgraph.de/sr/

