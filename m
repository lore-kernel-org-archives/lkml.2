Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab1GYMh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:37:27 -0400
Received: from ozlabs.org ([203.10.76.45]:46805 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab1GYMhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:37:22 -0400
X-Mailbox-Line: From anton@samba.org Mon Jul 25 12:34:26 2011
Message-Id: <20110725023311.175792493@samba.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 12:33:11 +1000
From: Anton Blanchard <anton@samba.org>
To: mingo@elte.hu, peterz@infradead.org, benh@kernel.crashing.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] ppc64 scheduler fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a set of ppc64 scheduler fixes that help with some
multi node performance issues.

