Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1EURsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 13:48:47 -0400
Received: from mail.perches.com ([173.55.12.10]:1820 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262Ab1EURsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 13:48:43 -0400
From: Joe Perches <joe@perches.com>
To: Ben Greear <greearb@candelatech.com>, linux-arch@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Add and use WARN_RATELIMIT
Date: Sat, 21 May 2011 10:48:38 -0700
Message-Id: <cover.1305999731.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <1305666832.1722.62.camel@Joe-Laptop>
References: <1305666832.1722.62.camel@Joe-Laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic mechanism to ratelimit WARN uses.

Joe Perches (2):
  bug.h: Add WARN_RATELIMIT
  net: filter: Use WARN_RATELIMIT

 include/asm-generic/bug.h |   16 ++++++++++++++++
 net/core/filter.c         |    4 +++-
 2 files changed, 19 insertions(+), 1 deletions(-)

-- 
1.7.5.rc3.dirty

