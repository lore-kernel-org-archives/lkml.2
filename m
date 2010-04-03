Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0DCApE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 20:45:04 -0400
Received: from mail.openrapids.net ([64.15.138.104]:43760 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754157Ab0DCAo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 20:44:59 -0400
Date: Fri, 2 Apr 2010 20:44:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng 0.205, 0.206, ltt-control 0.82 for Linux 2.6.33.2
Message-ID: <20100403004457.GA5992@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 20:40:15 up 70 days,  3:17,  2 users,  load average: 0.00, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here come the latest LTTng versions, bringing mostly bugfixes:

- LTTng 0.205 fixes a kref race in channel teardown vs lttd file open.
- LTTng 0.206 marks Immediate Values as BROKEN for PowerPC. Will be replaced by
  asm goto from mainline eventually anyway, so don't bother looking for the
  cause of the bug.
- ltt-control 0.82 ensures lttctl waits for lttd to complete when called at
  trace destruction in overwrite mode. Failure to do so can result in unread
  channels in flight recorder mode.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
