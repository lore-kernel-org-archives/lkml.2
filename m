Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1HHS6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:58:03 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43002 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1HHS57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:57:59 -0400
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC][PATCH 0/2] x86, CPU: Run stuff on the BSP
Date: Mon,  8 Aug 2011 20:57:50 +0200
Message-Id: <1312829872-20260-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Ok,

this is just an RFC and it builds but no further tests have been done on
it. The first patch is a trivial cleanup and can go in.

For the second one I opted to look at c->x86_vendor in cpu/common.c
which is not very clean but still simpler than adding a miscellaneous
struct to contain the ->run_on_bsp() pointer and be statically allocated
as __initdata, in the cpu_dev fashion. We can always do that later if
there's more ofthe similar functionality needed.

Hmm, so please take a look and let me know if this is going in the right
direction.

Thanks.
