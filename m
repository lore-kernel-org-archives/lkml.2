Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab0KZVJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:09:53 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:22798 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751399Ab0KZVJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:09:52 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 3kZcUu8VM1mmEY2bN_SPtN7X9iOsJ3avHqp1mXpg9n9NIk3
 PkAVr42JA7bMUqQaB5.fgakgZ4O2fpuOIf4ZeSg0ZPq0uyHZhILxUTUHPKMX
 1S099kz3xJcDjfyIzoFi1u4ulO_lafMwZScxT76WljaVtQlzuaeUPdTQjg4A
 KKcCn4p4p57DzmxfFHjAFObejS5Ez5RQQcREcT2gzyOi4Ibm.BQBsQkF2bsH
 ChPa6jnEb4uc-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101126210937.383047168@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 26 Nov 2010 15:09:37 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [thisops uV2 00/10] Upgrade of this_cpu_ops V2
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

V2 has several enhancements and bugfixes that were suggested.
