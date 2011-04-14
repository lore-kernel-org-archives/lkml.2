Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab1DNRAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:00:24 -0400
Received: from cobra.newdream.net ([66.33.216.30]:46873 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab1DNRAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:00:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=MJs7bALadWN1eP0iH1eY4Hdq079PjSmFp+oVXblghVd4TS26
	1ucWRWvwUgz/mv191ZGEp2mYB9PaMRW7SW2WzzCwUhPOYL9PXtzXr+o3nWeKF9/G
	5J6rwkZ20ReEC5OBauYjRZbZQv/ZsSyGPyCeD19AlsckGJoB5kACy60RDt0=
Date: Thu, 14 Apr 2011 10:03:58 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fix for 2.6.39-rc4
Message-ID: <Pine.LNX.4.64.1104060950440.18205@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

This might be the first time I've only had a single bug fix to push!  
This fixes a null dereference on RBD when an osd daemon restarts.  The 
patch in the last pull didn't get it quite right.

Thanks-
sage


Sage Weil (1):
      libceph: fix linger request requeueing

 net/ceph/osd_client.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)
