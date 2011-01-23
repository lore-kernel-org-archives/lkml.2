Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab1AWPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:16:58 -0500
Received: from www.tglx.de ([62.245.132.106]:58622 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1AWPQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:16:57 -0500
Message-Id: <20110123143631.392446736@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 23 Jan 2011 15:16:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 0/9] locking: Remove the deprecated lock initializers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED and RW_LOCK_UNLOCKED are deprecated since lockdep
was merged. Fixup the last pertinacious users and remove the initializers.

Thanks,

	tglx


