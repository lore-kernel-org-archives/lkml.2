Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab1ADXuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:50:39 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:37879 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab1ADXui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:50:38 -0500
X-Greylist: delayed 1576 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Jan 2011 18:50:38 EST
Message-Id: <20110104231629.996422888@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jan 2011 18:16:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC patch 0/5] Trace event fixes and cleanups
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  4 Jan 2011 23:24:19 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed a 2 bugs in TRACE_EVENT() users (unassigned fields), along with 3
inconsistencies in the Ftrace comments and macros, which should be considered as
cleanups.

I made sure to only include trivial patches that do not change anything
ABI-wise.

(tested against -tip)

Comments are welcome,

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
