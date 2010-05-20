Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0ETHyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:54:06 -0400
Received: from home.kolivas.org ([59.167.196.135]:59990 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab0ETHyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:54:04 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] BFS CPU scheduler v0.318 for 2.6.34
Date: Thu, 20 May 2010 17:54:00 +1000
User-Agent: KMail/1.12.4 (Linux/2.6.34-ck1; KDE/4.3.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005201754.00766.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to briefly announce the availability of the desktop interactivity 
focused BFS CPU scheduler v0.318 for the new stable linux 2.6.34 kernel. This 
version is also available for 2.6.32 and 2.6.31.


http://ck.kolivas.org/patches/bfs/


Apart from resyncing with the new kernel, the changes in this version since 
the last announced version 0.316 are minor only:

Making the rise in rr_interval with increasing CPUs smaller, for lower 
latencies on multicore/smp machines. Any decrease in throughput with this 
change was below the margin of noise in my basic testing, and if there was a 
drop in throughput it would be worth it for latency reasons.

Minor fixes to prevent a warning when sched debug is enabled.


Enjoy

-- 
-ck
