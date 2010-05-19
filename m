Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab0ESWAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 18:00:18 -0400
Received: from mail.openrapids.net ([64.15.138.104]:36381 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751041Ab0ESWAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 18:00:16 -0400
Date: Wed, 19 May 2010 18:00:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: [RELEASE] ltt-control 0.85, lighter page cache use
Message-ID: <20100519220015.GA8028@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:55:22 up 117 days, 32 min, 10 users,  load average: 0.28,
	0.21, 0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just released ltt-control 0.85 which waits for previous subbuffers to be
written to disk (using sync_file_range()) and uses fadvise to tell the kernel
that pages won't be reaccessed. This lessens the tracer impact on the page
cache.

Thanks to Linus for hints on how to use fadvise and sync_file_range to do
this, c.f.:

http://marc.info/?l=linux-kernel&m=127430576309253&w=2

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
