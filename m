Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab0ETRaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:30:21 -0400
Received: from lo.gmane.org ([80.91.229.12]:57227 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310Ab0ETRaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:30:20 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
Subject: SCHED_OMIT_FRAME_POINTER configuration option wrong
Date: Thu, 20 May 2010 18:30:07 +0100
Message-ID: <ht3riv$b5f$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 88-97-16-53.dsl.zen.co.uk
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

The configuration option SCHED_OMIT_FRAME_POINTER seems to have gained a 
most unusual description in 2.6.34.

490 config SCHED_OMIT_FRAME_POINTER
491         def_bool y
492         prompt "Single-depth WCHAN output"
493         depends on X86
494         ---help---
495           Calculate simpler /proc/<PID>/wchan values. If this option
496           is disabled then wchan values will recurse back to the
497           caller function. This provides more accurate wchan values,
498           at the expense of slightly more scheduling overhead.
499
500           If in doubt, say "Y".

Frank

