Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488Ab0GOPI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:08:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59698 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933421Ab0GOPI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:08:58 -0400
Subject: [PATCH 0/3] Kmemleak patches for 2.6.36-rc1
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 15 Jul 2010 16:08:56 +0100
Message-ID: <20100715150703.21793.94815.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-83-g972d5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2010 15:08:56.0487 (UTC) FILETIME=[A542C370:01CB242F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are three kmemleak patches that I plan to push during the upcoming
merging window. Thanks.


Catalin Marinas (2):
      kmemleak: Show more information for objects found by alias
      kmemleak: Add DocBook style comments to kmemleak.c

Jason Baron (1):
      kmemleak: Introduce a default off mode for kmemleak


 lib/Kconfig.debug |    7 ++++
 mm/kmemleak.c     |   98 +++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 82 insertions(+), 23 deletions(-)

-- 
Catalin
