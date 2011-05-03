Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab1ECO1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:27:00 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43848 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1ECO07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:26:59 -0400
Date: Tue, 3 May 2011 16:26:25 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] perf: Add persistent event facilities
Message-ID: <20110503142625.GF20241@aftab>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-3-git-send-email-bp@amd64.org>
 <20110503064046.GD7751@elte.hu>
 <20110503125929.GB1730@nowhere>
 <20110503133057.GD20241@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503133057.GD20241@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 09:30:57AM -0400, Borislav Petkov wrote:
> On Tue, May 03, 2011 at 08:59:35AM -0400, Frederic Weisbecker wrote:
> > On Tue, May 03, 2011 at 08:40:46AM +0200, Ingo Molnar wrote:
> > > [ kernel/hw_breakpoint.c could possibly move into kernel/events/hw_breakpoint.c 
> > >   file as well - if Frederic acks it. ]
> > 
> > Makes sense yeah.
> 
> Ok, looks trivial enough. Ingo, let me know if I should add it to the
> pull request from earlier.

I slapped it into a new branch along with the previous patch:

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git perf-event-rename-2

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
