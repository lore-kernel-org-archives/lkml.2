Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab0HTV2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 17:28:24 -0400
Received: from mail.openrapids.net ([64.15.138.104]:51482 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751038Ab0HTV2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 17:28:22 -0400
Date: Fri, 20 Aug 2010 17:28:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: [RELEASE] LTTng 0.224 for linux 2.6.35.2 (git tree patch fix)
Message-ID: <20100820212820.GA16946@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:20:48 up 209 days, 23:57,  3 users,  load average: 0.03, 0.10,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

LTTng 0.224 fixes socket instrumentation in the LTTng git tree: the patch hunk
management seems to differ slightly between quilt and git (hunks were at the
wrong offset when I rebased with quilt, but there was no fuzz), so only the git
tree showed this problem.

I guess quilt and git call patch with slightly different parameters. I simply
refreshed the patches with quilt and everything is fine now.

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
