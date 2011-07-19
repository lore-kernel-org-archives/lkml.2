Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab1GSSjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 14:39:48 -0400
Received: from cobra.newdream.net ([66.33.216.30]:56306 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1GSSjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 14:39:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=cYm7kMMzBOZUMs+K+g9AiPweBkQ/vx7Dn3ywTXAvCroeN7zp
	cKORWDaHkK776M6JK1RKuL2SnQPF0doydZvWSvEr9eAyAXDqgXA6TR/YT1lSfxz8
	zkooGujcIzmaL+9ycqRMPHmjcPIFF9MXneMiP8ugOgpr5E7aSPAO2FY2+1U=
Date: Tue, 19 Jul 2011 11:43:21 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
cc: ceph-devel@vger.kernel.org
Subject: [GIT PULL] Final ceph fix for 3.0
Message-ID: <Pine.LNX.4.64.1107191136530.11566@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have a last minute fix for a bug calculating the file access mode 
when O_APPEND|O_RDWR is passed to open.  Please pull/cherry-pick from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

Thanks!
sage


Sage Weil (1):
      ceph: fix file mode calculation

 net/ceph/ceph_fs.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)





