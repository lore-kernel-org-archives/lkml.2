Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0KRB5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 20:57:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077Ab0KRB4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 20:56:13 -0500
From: Josef Bacik <josef@redhat.com>
To: david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
        cluster-devel@redhat.com, joel.becker@oracle.com, jack@suse.cz
Subject: Hole Punching V3
Date: Wed, 17 Nov 2010 20:46:14 -0500
Message-Id: <1290044780-2902-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 3 of the hole punching series I've been posting.  Not much has
changed, the history is below

V2->V3
-FALLOC_FL_PUNCH_HOLE must also have FALLOC_FL_KEEP_SIZE in order to work
-formatting fixes

V1->V2
-Hole punching doesn't change file size
-Fixed the mode checks in ext4/btrfs/gfs2 so they do what they are supposed to

I've updated my local copies of the xfsprogs patches I have to test this to use
KEEP_SIZE and PUNCH_HOLE together, I'll post them after it looks like these
patches are good to go, including the manpage update.  The xfstest I wrote ran
fine both on xfs and btrfs (failing on btrfs obviously).  Thanks,

Josef
