Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0LRPYa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:24:30 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:40252 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab0LRPY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:24:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=MWW41YNeSNmxomEffwJfpjWwEVMJU5HEvwmJYqPQS8iAt0Kcl4DetWDiy9CExcdovw
         B0ZTvIA6ruuIyrLovA55Z6O/+3fSApILXgksrHTg6AkauoLRG2q0VexlS2o+aZvRauuP
         Wg/3wKcWuvxMnDy+rZC//Oqem3+9VAAVq7CTU=
From: Tejun Heo <tj@kernel.org>
To: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, hpa@zytor.com,
        mathieu.desnoyers@efficios.com
Subject: [PATCHSET percpu#this_cpu_ops] add this_cpu_{add_return|[cmp]xchg}() operations
Date: Sat, 18 Dec 2010 16:24:06 +0100
Message-Id: <1292685852-12469-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here are the patches that I applied to percpu#this_cpu_ops branch.
This branch won't be rebased and contains only the commits which
implement the new this_cpu_* ops, so that it can be pulled into other
trees without patches which make use of the operations which modify
other subsystems.

Christoph, I rearranged things a bit to make it conform better to the
overall organization.  It would be great if you can go over it once
just in case.

There are two git branches.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git this_cpu_ops
 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-2.6.38

Both branches won't be rebased.  this_cpu_ops contains only patches
from this series.  for-2.6.38 contains other percpu changes mostly
composed of patches which apply this_cpu_*() ops.

Thank you.

--
tejun
