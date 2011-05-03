Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1ECPcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:32:22 -0400
Received: from mail.perches.com ([173.55.12.10]:1172 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab1ECPcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:32:21 -0400
Subject: Re: [PATCH 3/4] x86, mce: Add persistent MCE event
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
In-Reply-To: <20110503152224.GG20241@aftab>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
	 <1304357691-14354-4-git-send-email-bp@amd64.org>
	 <20110503064401.GE7751@elte.hu> <20110503071833.GB18979@aftab>
	 <1304435656.1788.8.camel@Joe-Laptop>  <20110503152224.GG20241@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 08:32:19 -0700
Message-ID: <1304436739.1788.12.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 17:22 +0200, Borislav Petkov wrote:
> On Tue, May 03, 2011 at 11:14:16AM -0400, Joe Perches wrote:
> > On Tue, 2011-05-03 at 09:18 +0200, Borislav Petkov wrote:
> > > On Tue, May 03, 2011 at 02:44:01AM -0400, Ingo Molnar wrote:
> > > > * Borislav Petkov <bp@amd64.org> wrote:
> > []
> > > > > +static struct dentry *mce_add_event_debugfs(struct perf_event *event, int cpu)
> > > > > +{
> > > > > +	char buf[14];
> > > > > +
> > > > > +	sprintf(buf, "mce_record%d", cpu);
> > trivia:
> > buf[14] doesn't fit 10k+ cpus.
> I'll fix that when someone comes up with a x86 system that supports 10k+
> CPUs with a single system image :).

Your choice.

I think leaving trivially fixable known defects around
isn't good engineering, but maybe that's just me.

