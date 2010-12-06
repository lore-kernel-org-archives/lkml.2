Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab0LFRQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:16:39 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:23968 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752050Ab0LFRQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:16:38 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: UejbGd8VM1l4yFp7ub.MnclRL1G4nDOyJcXsfIh3fTPifGp
 .58EJTGyX3emIq7X5XQrhuSxTNUbLgEoTZeGxAECki6h6VDRJ2Rfl.9GY.bI
 4ZI0ZB75doigtQvmvCOoxo9kxkHZRdPRGTGkOnH9X.itj6rQgqaenyG_LCZg
 yqeqPFC97hE4ChvTvUUrIXuVdozYy4iUb6cHcv_61tn_Q7Y878PT5ty_Tbe2
 Nj.CI.60EYlaag6HbzSdyWOJ_vq3zGEfu7w4YZKA-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206171618.302060721@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:16:18 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [Use cpuops V1 00/11] Use this_cpu_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the this_cpu_ops in various parts of the kernel.

This patchset does not require any upgrade of the percpu infrastructure. The
patches included here are simple replacements of operations on percpu
variables with the more efficient and compact code provide by this_cpu_ops.

These patches can be individually applied and are not depending on any other
patches. I would suggest they go through Tejun's percpu tree if they are not
picked up by the maintainers of the subsystems affected.

