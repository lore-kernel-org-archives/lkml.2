Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab0HSPko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:40:44 -0400
Received: from mail.openrapids.net ([64.15.138.104]:56389 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751379Ab0HSPkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:40:41 -0400
Date: Thu, 19 Aug 2010 11:40:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng 0.222 for kernel 2.6.34.4
Message-ID: <20100819154039.GA6404@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:41:14 up 208 days, 16:17,  4 users,  load average: 0.07, 0.04,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

LTTng 0.222 is rebased on the latest 2.6.34.4 stable release. This is the last
LTTng revision before moving to 2.6.35.

It includes a fixup to follow changes introduces to splice.c in 2.6.34.2, where
the checks for seekable files changed subtly. Eventually I'll have to implement
a proper seek rather than dealing with this at the lttng splice actor level, but
for now just setting the extra fmode flags works upon open works well.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
