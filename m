Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab1GETvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:51:10 -0400
Received: from cobra.newdream.net ([66.33.216.30]:44884 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab1GETvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:51:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=HOHqYHMF3ElPFhTFElD7CpcoeWoC0Qsa4XzIvCDlLkmnTRio
	c66FDmpySi1AvgIiHtVnq/zIsj+Wfdtw+6Uqj0T9HvgAGDg3fowRV4WEEeMl35Uo
	wfY79Vy0MjSmzD+s2WzFeHNxTjJAYl0plX1ZtIkckhUsGO2AUpitEx0S2K8=
Date: Tue, 5 Jul 2011 12:54:07 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 3.0
Message-ID: <Pine.LNX.4.64.1107051250370.5147@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

These are all related to issues with O_DIRECT when the pointer and IO 
alignments do not match, and/or when there are holes in the file.

Thanks!
sage


Sage Weil (3):
      ceph: fix page alignment corrections
      libceph: fix page calculation for non-page-aligned io
      ceph: fix sync and dio writes across stripe boundaries

 fs/ceph/file.c        |   14 ++++++--------
 net/ceph/osd_client.c |   10 ++++++----
 2 files changed, 12 insertions(+), 12 deletions(-)
