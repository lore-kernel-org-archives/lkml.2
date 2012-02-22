Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab2BVLfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 06:35:17 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:62160 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab2BVLfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 06:35:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20292.54000.294711.784387@pilspetsen.it.uu.se>
Date: Wed, 22 Feb 2012 12:35:12 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: internal compiler error for: in move_insn, at haifa-sched.c:2314
In-Reply-To: <201202221104.30548.toralf.foerster@gmx.de>
References: <201202221104.30548.toralf.foerster@gmx.de>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toralf =?utf-8?q?F=C3=B6rster?= writes:
 > 
 > Hello,
 > 
 > the build (.config attached) failed, make ends with :
 > ...
 >   CC      kernel/power/main.o
 >   CC      kernel/power/qos.o
 > kernel/power/qos.c: In function 'pm_qos_get_value':
 > kernel/power/qos.c:143:1: warning: control reaches end of non-void function
 >   CC      kernel/power/process.o
 >   CC      kernel/power/suspend.o
 >   CC      kernel/power/poweroff.o
 >   LD      kernel/power/built-in.o
 >   CC      kernel/sched/core.o
 > kernel/sched/core.c: In function 'pick_next_task':
 > kernel/sched/core.c:3145:1: warning: control reaches end of non-void function
 > kernel/sched/core.c: In function 'update_rq_clock':
 > kernel/sched/core.c:123:1: internal compiler error: in move_insn, at haifa-sched.c:2314
 > Please submit a full bug report,
 > with preprocessed source if appropriate.
 > See <http://bugs.gentoo.org/> for instructions.

Please report this to gentoo, as instructed above.
