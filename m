Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab0DLNEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 09:04:13 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51805 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab0DLNEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 09:04:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=vDhth9Zzdbf+R4Ere8Qb6yaZVU3XCSlH5Vbk5oz+MbeoaVp9LxYEWZybQg2MGOiB5O
         FAlFD5ZdyGRAI52k3TTqAkvl/O6CPWc+0Ir7NcljIWBPlsVjJ0hp21cBRsUZU/Z4b8Py
         vqDwkDbcOcg/lbHfvaPyKhdg8Jlmg3Cu35trc=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, hch@infradead.org,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/4] blkdev: blkdev_issue_fn cleanups v2
Date: Mon, 12 Apr 2010 17:03:53 +0400
Message-Id: <1271077437-7921-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Convert all blkdev_issue_xxx function to common set of flags
- move common functions to block/blk-lib.c
- Add generic zeroout helper

changes from V1
Christoph is about to change discard memory payload allocation logic
so discard cleanups are no longer necessary.
