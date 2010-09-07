Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab0IGOA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:00:57 -0400
Received: from www.tglx.de ([62.245.132.106]:58769 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab0IGOAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:00:45 -0400
Message-Id: <20100907111326.202980881@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 13:59:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 0/3] audit: Fixes and tasklist_lock -> RCU conversion - Resend
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the following patches result from auditing read_lock(&tasklist_lock)
sites whether they can be converted to RCU.

Resend of http://lkml.org/lkml/2009/12/9/216

Thanks,

	tglx



