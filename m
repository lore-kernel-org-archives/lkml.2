Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab1ECPW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:22:58 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36187 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab1ECPW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:22:57 -0400
Date: Tue, 3 May 2011 17:22:24 +0200
From: Borislav Petkov <bp@amd64.org>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH 3/4] x86, mce: Add persistent MCE event
Message-ID: <20110503152224.GG20241@aftab>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-4-git-send-email-bp@amd64.org>
 <20110503064401.GE7751@elte.hu>
 <20110503071833.GB18979@aftab>
 <1304435656.1788.8.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304435656.1788.8.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 11:14:16AM -0400, Joe Perches wrote:
> On Tue, 2011-05-03 at 09:18 +0200, Borislav Petkov wrote:
> > On Tue, May 03, 2011 at 02:44:01AM -0400, Ingo Molnar wrote:
> > > * Borislav Petkov <bp@amd64.org> wrote:
> []
> > > > +static struct dentry *mce_add_event_debugfs(struct perf_event *event, int cpu)
> > > > +{
> > > > +	char buf[14];
> > > > +
> > > > +	sprintf(buf, "mce_record%d", cpu);
> 
> trivia:
> 
> buf[14] doesn't fit 10k+ cpus.

I'll fix that when someone comes up with a x86 system that supports 10k+
CPUs with a single system image :).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
