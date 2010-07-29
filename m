Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab0G2Kr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:47:56 -0400
Received: from sh.osrg.net ([192.16.179.4]:60127 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756898Ab0G2Kry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:47:54 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/2] Documentation: DMA API updates
Date: Thu, 29 Jul 2010 19:45:06 +0900
Message-Id: <1280400308-16114-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 29 Jul 2010 19:47:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch adds the description of how to support multiple types
of IOMMUs (i.e. include/asm-generic/dma-mapping-common.h).

The second patch adds PCI DMA unamp state API to
feature-removal-schedule.txt. It was replaced with the DMA unamp state
API (which can be used for any bus). There is no users of PCI DMA
unamp state API in linux-next. August 2012 is long enough, I suppose.

=
 Documentation/DMA-API-HOWTO.txt            |   10 ++++++++++
 Documentation/feature-removal-schedule.txt |    9 +++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)
