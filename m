Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab0LHRzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:55:47 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:40817 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755102Ab0LHRzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:55:45 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: G8b8tJYVM1ntLrIbKiCSOBv9pdrCApWMpZMM6N51OIlP47L
 gi8dOxZLOSNM76sKGfVjlsa8sG3snbOF.djiBYHNrhqsKPr_s0P.wNjj.WQM
 5V5M3Cl_8hZm_NFkUBpst2cAqZWmErimuYbwl74sw02S8yK4BkHbxB5vlYss
 GW7ATFx7CQcO7BWpYWbWkj8qyfbxwTX7cbhH8dhBDHBh9kCxPjsPkBkBdbPl
 mX4.tatYwUvyaERA-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101208175520.456864019@linux.com>
User-Agent: quilt/0.48-1
Date: Wed, 08 Dec 2010 11:55:20 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg V1 0/4] Cmpxchg and xchg operations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cmpxchg and xchg operations to the cpu ops and use them for irq handling
and for vm statistics.

