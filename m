Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab1JGR1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 13:27:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34402 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1JGR1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 13:27:01 -0400
From: Nasir Abed <nasirabed@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        venki@google.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 0/1] x86: removed deprecated IRQF_DISABLED
Date: Fri,  7 Oct 2011 19:26:19 +0200
Message-Id: <1318008380-3379-1-git-send-email-nasirabed+kernel@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removed IRQF_DISABLED which is deprecated and is ignored anyway since 2.6.36.

[PATCH 1/1] x86: removed deprecated IRQF_DISABLED
