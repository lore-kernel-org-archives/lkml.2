Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab0JNVKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:10:20 -0400
Received: from canuck.infradead.org ([134.117.69.58]:56096 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0JNVKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:10:18 -0400
Message-Id: <20101014203404.222133139@chello.nl>
User-Agent: quilt/0.47-1
Date: Thu, 14 Oct 2010 22:34:04 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>
Subject: [RFC][PATCH 0/7] perf and jump_label bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only compile tested, but should fix the pending hw_breakpoint issue and
use jump_labels to optimize some of perf

