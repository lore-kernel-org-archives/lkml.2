Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1ADPMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:12:30 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54993 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab1ADPM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:12:28 -0500
Message-Id: <20110104145929.772813816@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jan 2011 15:59:29 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 00/18] sched: Reduce runqueue lock contention -v4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest version of the scary patches...


