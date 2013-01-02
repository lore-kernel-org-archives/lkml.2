Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab3ABT3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 14:29:51 -0500
Received: from cobra.newdream.net ([66.33.216.30]:59891 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3ABT3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 14:29:47 -0500
Date: Wed, 2 Jan 2013 11:29:46 -0800 (PST)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 3.8-rc2
Message-ID: <alpine.DEB.2.00.1301021127210.6371@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these Ceph fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

Two of Alex's patches deal with a race when reseting server connections 
for open RBD images, one demotes some non-fatal BUGs to WARNs, and my 
patch fixes a protocol feature bit failure path.

Thanks!
sage


----------------------------------------------------------------
Alex Elder (3):
      libceph: move linger requests sooner in kick_requests()
      libceph: always reset osds when kicking
      libceph: WARN, don't BUG on unexpected connection states

Sage Weil (1):
      libceph: fix protocol feature mismatch failure path

 net/ceph/messenger.c  |   23 ++++++++---------------
 net/ceph/osd_client.c |   34 +++++++++++++++++++++-------------
 2 files changed, 29 insertions(+), 28 deletions(-)
