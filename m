Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab2JVWZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 18:25:06 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:43649 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab2JVWZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 18:25:04 -0400
Message-ID: <5085C7B6.2030108@oracle.com>
Date: Mon, 22 Oct 2012 17:24:54 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121012 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, jfs-discussion@lists.sourceforge.net
Subject: [GIT PULL] jfs bug fix for 3.7
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8d2b6b3ae280dcf6f6c7a95623670a57cdf562ed:

  Merge tag 'sh-for-linus' of git://github.com/pmundt/linux-sh (2012-10-16 19:24:00 -0700)

are available in the git repository at:


  git://github.com/kleikamp/linux-shaggy.git tags/jfs-3.7-2

for you to fetch changes up to 4e7a4b01222343481d8ff084dbef9b80f7089a19:

  jfs: Fix FITRIM argument handling (2012-10-17 09:18:38 -0500)

----------------------------------------------------------------
Bug fix: Fix FITRIM argument handling

----------------------------------------------------------------
Lukas Czerner (1):
      jfs: Fix FITRIM argument handling

 fs/jfs/jfs_discard.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)
