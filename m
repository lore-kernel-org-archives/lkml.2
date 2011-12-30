Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab1L3EvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 23:51:01 -0500
Received: from cobra.newdream.net ([66.33.216.30]:48394 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab1L3Eu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 23:50:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=B8TKbtaVMLR0hpzcVNbT3LPEFmK0ox8PTA2ZH0EGqLVlDEiV
	IUwjZCxzZU6bYgcAmYAXKZG4hqgivefa7ZXfbLmzICF6Nq9XL6DVZ6fUxVAbN8hD
	FGjzbnHGG2Ex/3M5yi1gkkpbewiKbGZ0VUT5wEecdrWeKcAjNxRfAXvL6rU=
Date: Thu, 29 Dec 2011 20:50:56 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 3.2 final
Message-ID: <Pine.LNX.4.64.1112281837400.18151@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this Ceph patch from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There are a few lingering issues in Ceph's use of the dcache for readdir 
that we weren't able to nail down, so this patch disables it for now.  
There will be a series of patches for the next release that reenable this 
(via a mount option) and clean things up a bit.

Thanks!
sage


Sage Weil (1):
      ceph: disable use of dcache for readdir etc.

 fs/ceph/dir.c |   29 +++--------------------------
 1 files changed, 3 insertions(+), 26 deletions(-)
