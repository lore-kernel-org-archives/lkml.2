Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab2FXPCB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 11:02:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab2FXPCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 11:02:00 -0400
Date: Sun, 24 Jun 2012 16:59:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] uprobes: write_opcode() cleanups
Message-ID: <20120624145936.GA23269@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

write_opcode() cleanups resend + new minor fix.

Changes:

	- document the new argument in 2/5.

	- drop the buggy 5/5, thanks Anton for your quick nack.
	  Probably I'll return to this later, I have another reason
	  for this change.

	- so this 5/5 is new.

Srikar, please add your acks unless you have some objections.

Oleg.

