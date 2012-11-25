Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab2KYWdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 17:33:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab2KYWdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 17:33:49 -0500
Date: Sun, 25 Nov 2012 23:33:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] uprobes: Kill uprobes_mutex[]
Message-ID: <20121125223331.GA24788@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On top of "[PATCH 0/4] uprobes: locking changes for filtering"

No functional changes. But uprobes_mutex[] must die imho.
And alloc_uprobe() should be separated from __register.

Oleg.

