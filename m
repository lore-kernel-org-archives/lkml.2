Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab1ECMvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 08:51:55 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40196 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab1ECMvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 08:51:54 -0400
Date: Tue, 3 May 2011 14:51:19 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Rename perf_event.c
Message-ID: <20110503125119.GC20241@aftab>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-3-git-send-email-bp@amd64.org>
 <20110503064046.GD7751@elte.hu>
 <20110503071215.GA18979@aftab>
 <20110503082234.GB6999@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503082234.GB6999@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 04:22:34AM -0400, Ingo Molnar wrote:
> Could you send a Git pull request against perf/core that does the
> obvious file movement and renaming? We can do that first step straight
> away and get the ball rolling.

Sure, here we go:

The following changes since commit ac0a3260f37b8616da8d33488ec94b94e6ae5b31:

  Merge branch 'tip/perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace into perf/core (2011-05-01 19:11:42 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git perf-event-rename

Borislav Petkov (1):
      perf: Start the restructuring

 kernel/Makefile                        |    5 +++--
 kernel/events/Makefile                 |    5 +++++
 kernel/{perf_event.c => events/core.c} |    0
 3 files changed, 8 insertions(+), 2 deletions(-)
 create mode 100644 kernel/events/Makefile
 rename kernel/{perf_event.c => events/core.c} (100%)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
