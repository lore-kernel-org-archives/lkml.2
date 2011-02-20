Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab1BTPRb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 10:17:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46131 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab1BTPRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 10:17:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UsNQpZtIym3QeSUQhoExeO44HPDNY6nCz+SqNmz/vHsBKAfbdbzibVCaHJ22dkwUf6
         /Ma4Mje+RWGZAEnCgGLbhSY4uxoA7tVxGeOIu0DPdIGMN5/nHqFAA5/QjsKbD4mIbWYt
         fgnxhNK7k9Vmp4mlte1y9ift7pJ5VMlTuZIKw=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v2 0/2] memcg: migration clean up
Date: Mon, 21 Feb 2011 00:17:16 +0900
Message-Id: <cover.1298214672.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up memcg migration.
This patch sent Tue, Jan 11, 2011 but maybe Andrew was very busy so lost.
I resend with Acked-by and rebased on mmotm-2011-02-04.

Minchan Kim (2):
  memcg: remove unnecessary BUG_ON
  memcg: remove charge variable in unmap_and_move

 mm/memcontrol.c |    1 +
 mm/migrate.c    |   10 +++-------
 2 files changed, 4 insertions(+), 7 deletions(-)

