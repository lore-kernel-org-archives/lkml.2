Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab1HAKxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:53:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33700 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1HAKxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:53:12 -0400
From: Per Forlin <per.forlin@linaro.org>
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH -mmotm 0/2] fault-injection: improve naming and export symbols
Date: Mon,  1 Aug 2011 12:52:35 +0200
Message-Id: <1312195957-12223-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset depends on
fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory.patch

The main purpose of this patchset is to add ability for modules to utilize
the fault injection. MMC needs this in order to implement fault injection.

Per Forlin (2):
  fault-injection: improve naming of public function should_fail()
  fault-injection: export fault injection functions

 Documentation/fault-injection/fault-injection.txt |    8 ++++----
 block/blk-core.c                                  |    3 ++-
 block/blk-timeout.c                               |    2 +-
 include/linux/fault-inject.h                      |    2 +-
 lib/fault-inject.c                                |    4 +++-
 mm/failslab.c                                     |    2 +-
 mm/page_alloc.c                                   |    2 +-
 7 files changed, 13 insertions(+), 10 deletions(-)

-- 
1.7.4.1

