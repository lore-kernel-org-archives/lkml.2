Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab0L1VE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 16:04:27 -0500
Received: from mail.openrapids.net ([64.15.138.104]:57227 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750975Ab0L1VE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 16:04:26 -0500
Date: Tue, 28 Dec 2010 16:04:22 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: tiwg@multicore-association.org
Cc: Tim Bird <tim.bird@am.sony.com>,
        Tasneem Brutch - SISA <t.brutch@sisa.samsung.com>,
        Steve Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
        linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] BabelTrace relicensing from LGPLv2.1 to MIT-style
Message-ID: <20101228210422.GA25127@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:48:25 up 35 days,  1:51,  6 users,  load average: 0.21, 0.09,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to popular demand, I changed the licensing of the BabelTrace trace
conversion library from LGPL to MIT (BSD style)
(tree: http://git.efficios.com/?p=babeltrace.git
commit ccd7e1c86f36342b0b06651cc52df86bb663c271)

This is done in the spirit of sharing the prototype reference implementation of
the Common Trace Format (CTF: http://www.efficios.com/ctf) within the BabelTrace
trace converter with the industry, allowing uses in proprierary operating
systems and in hardware devices generating traces, as well as simplifying
reimplementation of the CTF read-side in different languages, for instance in
Java for the Eclipse Tracing and Monitoring Framework. The goal here is to favor
a wide acceptance of the trace format both in tracers and trace analysis tools.
The CTF read-side part of the BabelTrace library is designed to be reused within
trace analysis tools.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
