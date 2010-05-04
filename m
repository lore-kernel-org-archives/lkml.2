Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494Ab0EDDpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 23:45:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64819 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab0EDDpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 23:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=FxMD00rWq7kX5UKQ3WbSvisYcr45cEBVgtvlo86259pkPz4aQvCBBdS9u9/4q+YB3R
         U5RkJNUsHnz+cvM0U2jlS5xCvrk5CMj92b6v54UatJV7hSx/8qhuOQc7gSFDkXviBsye
         bBvX3Gn4AXRR1CkP6/k6so+mFKbqedvhDVrcA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL] lockdep stat fixes
Date: Tue,  4 May 2010 05:45:33 +0200
Message-Id: <1272944736-25141-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the core/locking branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	core/locking

Thanks,
	Frederic
---

Frederic Weisbecker (3):
      lockdep: Provide off case for redundant_hardirqs_on increment
      lockdep: Actually _dec_ in debug_atomic_dec
      lockdep: No need to disable preemption in debug atomic ops


 kernel/lockdep.c           |    2 +-
 kernel/lockdep_internals.h |    8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)
