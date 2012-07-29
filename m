Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab2G2SYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 14:24:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab2G2SYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 14:24:30 -0400
Date: Sun, 29 Jul 2012 20:21:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Arapov <anton@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/14] uprobes: acked patches
Message-ID: <20120729182128.GA20269@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Re-send. No changes, just added the acks from Srikar.

"uprobes: mmap_region() corrupts mm->mm_rb if uprobe_mmap() fails"
I sent yesterday doesn't depend on this series, it can go ahead
to fix the serious problem.

Oleg.

