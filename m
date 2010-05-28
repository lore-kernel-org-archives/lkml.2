Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab0E1UGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 16:06:13 -0400
Received: from bosmailout10.eigbox.net ([66.96.184.10]:51033 "EHLO
	bosmailout10.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab0E1UGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 16:06:08 -0400
X-EN-OrigOutIP: 10.20.18.16
X-EN-IMPSID: P7YG1e0010LoEWa017YGGM
Message-ID: <4C001888.8020006@jaysonking.com>
Date: Fri, 28 May 2010 14:24:56 -0500
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Stable team <stable@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
CC: "Theodore Ts'o" <tytso@mit.edu>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Dave Chinner <david@fromorbit.com>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       "Jayson R. King" <dev@jaysonking.com>,
       Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
Subject: [PATCH 2.6.27.y 0/3] ext4 fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 68.93.139.172
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

This is a second try at sending ext4 fixes to 2.6.27.y, including an
important deadlock fix from kernel bugzilla #12579. The patches were
dropped the first time because they depended on a vfs patch which was
recently found to be broken on mainline. Now, the vfs patch is not
included in this set, only ext4 patches.

Here are the three patches I'm proposing for inclusion in 2.6.27.y:

Theodore Ts'o (1):
      ext4: Use our own write_cache_pages()

Aneesh Kumar K.V (2):
      ext4: Fix file fragmentation during large file write.
      ext4: Implement range_cyclic in ext4_da_writepages instead of write_cache_pages

They will be posted as replies to this message.

I have made some changes to the first two patches to adapt them for the
current 2.6.27.47 tree. The changes are detailed between brackets above
my signed-off line for each.

Jayson


