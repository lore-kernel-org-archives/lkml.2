Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab0DCOQi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 10:16:38 -0400
Received: from mail.openrapids.net ([64.15.138.104]:60095 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753978Ab0DCOQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 10:16:36 -0400
Date: Sat, 3 Apr 2010 10:16:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng 0.208 for Linux 2.6.33.2
Message-ID: <20100403141634.GA10953@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:13:21 up 70 days, 16:50,  2 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng 0.208 uses waits with msleep() rather than cpu_relax() while waiting for
file descriptor users to release it. This will handle !PREEMPT UP configs
correctly.

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
