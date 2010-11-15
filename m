Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab0KORO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:14:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757941Ab0KOROw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:14:52 -0500
From: Josef Bacik <josef@redhat.com>
To: david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com
Subject: Hole Punching V2
Date: Mon, 15 Nov 2010 12:05:17 -0500
Message-Id: <1289840723-3056-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 2 of the hole punching series I posted last week.  The following
things have changed

-Hole punching doesn't change file size
-Fixed the mode checks in ext4/btrfs/gfs2 so they do what they are supposed to

I posted updates to xfstests and xfsprogs in order to test this new interface,
and ran the test on xfs to make sure hole punching worked properly for xfs and I
tested it on btrfs to make sure it failed properly.  This series also adds
support for doing hole punching to ocfs2, but I did not test this part of it,
albiet it's an obvious fix so it should work fine.  Thanks,

Josef
