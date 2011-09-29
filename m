Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab1I2LCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 07:02:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33744 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752768Ab1I2LCa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 07:02:30 -0400
Subject: [PATCH 0/4] Kmemleak patches for -next
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 29 Sep 2011 12:02:17 +0100
Message-ID: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-118-g0cb4
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Sep 2011 11:02:25.0473 (UTC) FILETIME=[454CE310:01CC7E97]
X-MC-Unique: 111092912022802101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a set of kmemleak improvements which I would like to push to my
for-next branch. The second patch touches the percpu code, so it needs
ack from the corresponding maintainers (cc'ed).

Thanks.


Catalin Marinas (4):
      kmemleak: Show where early_log issues come from
      kmemleak: Handle percpu memory allocation
      kmemleak: When the early log buffer is exceeded, report the actual number
      kmemleak: Report previously found leaks even after an error


 mm/kmemleak.c |   80 ++++++++++++++++++++++++++++++++++++++++-----------------
 mm/percpu.c   |   22 +++++++++++++++-
 2 files changed, 77 insertions(+), 25 deletions(-)

-- 
Catalin

