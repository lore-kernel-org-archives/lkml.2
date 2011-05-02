Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab1EBRfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 13:35:41 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45599 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab1EBRfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 13:35:37 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/4] RAS daemon: kernel part
Date: Mon,  2 May 2011 19:34:47 +0200
Message-Id: <1304357691-14354-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

as previously discussed, here's the first part of the RAS daemon code
in smaller, broken-out, digestible pieces. No functionality change from
the last time, only commit message fixups, clarifications and comment
adjustments.

Concerning risk, I don't see any since patch 4/4 leaves the persistent
event disabled for now - sort of like a chicken bit - and can only be
enabled if explicitly stated so on the kernel command line.

Please review,
thanks.
