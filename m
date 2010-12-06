Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab0LFRkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:40:16 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:42340 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752395Ab0LFRkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:40:15 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: M.m4na4VM1l5FzqOY4tCg88OJ8TgE4bAx.S.HmBb4YF6mxH
 62CtD6_KYpbYQGFLPUZXySpzLy0DUqluwRYDAfAIyJXsXqKRUPhNmwJPse1T
 jr.9c.ZAzTyfpjshF_b4gAWkpZvKVoidBbNZOd54eP6tG5eGDaR62Av6rRwD
 zkx8EoZX6fGWQQ1obB8T6qmLqcDmkrH.dIAJWXN31FtmgKNcF4lDVp_imJ1C
 BRFyqawYA3MkMphJXomurWv7MflJwF2rT2HWn7YQ-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206173958.685460926@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:39:58 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops inc_return V1 0/9] Implement this_cpu_inc_return (and friends) and use it in various places
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the this_cpu_ops infrastructure to support this_cpu_inc_return and
then use the new functionality in various subsystems. Provide an optimize x86
implementation for these operations.

All these patches depends on the initial patch being applied first.

Patches have been reviewed a couple of times and I would suggest that
they go through Tejun's percpu tree for merging.

