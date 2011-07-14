Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1GNCYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 22:24:07 -0400
Received: from iabervon.org ([66.92.72.58]:43583 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab1GNCYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 22:24:06 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jul 2011 22:24:05 EDT
Date: Wed, 13 Jul 2011 22:10:13 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Christoph Hellwig <hch@tuxera.com>
cc: linux-kernel@vger.kernel.org
Subject: Problems with hfsplus on ipods in 2.6.38+
Message-ID: <alpine.LNX.2.00.1107131942190.2056@iabervon.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got an ipod which doesn't work with 2.6.38 or later, unless I revert:

358f26d52680cb150907302d4334359de7dd2d59
52399b171dfaea02b6944cd6feba49b624147126

In the failing case, I get:

 sd 2:0:0:0: [sdb] Bad block number requested
 hfs: unable to find HFS+ superblock

in dmesg when I try to mount it.

Before 2.6.38, or with those commits reverted, it mounts fine and works so 
far as I can tell. (There's an Ubuntu bug report: 
https://bugs.launchpad.net/ubuntu/+source/util-linux/+bug/734883, which 
reports other people having similar results). I can test patches and 
collect information that might be helpful, if you have any ideas.

	-Daniel
*This .sig left intentionally blank*
