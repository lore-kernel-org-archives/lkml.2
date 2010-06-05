Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426Ab0FEOMb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 10:12:31 -0400
Received: from outbound-mail02.westnet.com.au ([203.10.1.243]:5147 "EHLO
	outbound-mail02.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933400Ab0FEOMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 10:12:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlJPAA74CUw6B9wNPGdsb2JhbACHb5ZlDAEBAQE1LbAXjTGFFwSDSA
X-IronPort-AV: E=Sophos;i="4.53,366,1272816000"; 
   d="scan'208";a="82293877"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: patches to file r8192U_core.c
Date: Sat,  5 Jun 2010 22:12:24 +0800
Message-Id: <1275747158-31375-1-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


checkpatch.pl issues which appear in these patches are not new problems but problems
I ignored while working on the comments or those which will require an actual developer
to consider. In particular printk() problems.
I hope these patches will be helpful and I will continue working to fix the other issues
that I can handle.

Mike
