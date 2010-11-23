Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab0KWXwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:52:01 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:43682 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754217Ab0KWXwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:52:00 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ufskxwoVM1nxj.qvt.3Am9N3e5V7QbDWEavL0hrGNP92xIZ
 AqDYCIvZw5rehoPqZkyLoL0thcK1TctgIxFFZjZ5H9XUXhyEV65o2OQZKt91
 3ZUHHOEvSOV_3V1SRRrPx3NuZqQ3RPvnUIqMMRA9FOPDFGfqSd263rnKmwEc
 kklfGlJ0xxp37slhGM3_RlXSb2wH.dlVp5GlVPACB3bnxwnCvhQfkF5S_uh8
 P9eB0NoGHR1A-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101123235139.908255844@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Nov 2010 17:51:39 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [thiscpuops upgrade 00/10] Upgrade of this_cpu_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A patchset that adds more this_cpu operations and in particular RMV operations
that can be used in various places to avoid address calculations and
memory accesses.

Also adds this_cpu_cmpxchg_double() which is a locally atomic version of
cmpxchg and uses that to demo how a lockless, preemptless fastpath for
memory allocation could work. Works good enough so that I can write this
email with that fastpath scheme.

