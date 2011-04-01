Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab1DAE2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 00:28:43 -0400
Received: from mail.openrapids.net ([64.15.138.104]:56654 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750936Ab1DAE2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:28:42 -0400
Date: Fri, 1 Apr 2011 00:28:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Cc: Avik Sil <avik.sil@linaro.org>, Steve Langasek <steve.langasek@linaro.org>,
        John Rigby <john.rigby@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: [RELEASE] LTTng 0.248 for kernel 2.6.38.2
Message-ID: <20110401042837.GA32106@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 23:54:32 up 128 days,  8:57,  6 users,  load average: 0.25, 0.08,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng, the Linux Trace Toolkit Next Generation, is a project that aims
at producing a highly efficient full system tracing solution. It is
composed of several components to allow tracing of the kernel, of
userspace, trace viewing and analysis and trace streaming. LTTng is
open source software. It is being actively developed with the community.

Changelog:

* LTTng 0.248
  * Rebased on latest stable kernel (2.6.38.2).
  * Fix a quilt vs git lockdep patch hunk error (all quilt patches
    refreshed).
  * Merge a OMAP4 trace clock fix.

Project website: http://lttng.org
Download link: http://lttng.org/content/download
(please refer to the LTTng Manual for installation instructions)

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
