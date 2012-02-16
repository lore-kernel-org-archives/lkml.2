Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab2BPSSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 13:18:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab2BPSSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 13:18:09 -0500
Date: Thu, 16 Feb 2012 15:35:34 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 0/8] perf tool: parser generator for events parsing
Message-ID: <20120216173534.GG27941@infradead.org>
References: <1329393652-6055-1-git-send-email-jolsa@redhat.com> <1329411783.2293.257.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329411783.2293.257.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 16, 2012 at 06:03:03PM +0100, Peter Zijlstra escreveu:
> On Thu, 2012-02-16 at 13:00 +0100, Jiri Olsa wrote:
> > hi,
> > here's new version of event parsing patchset.
> > 
> > I saw Arnaldo already sent patches 1-3 to Ingo, but they did not make it
> > to the tree yet, so I'm still attaching them here.

Right, I'll take the rest (read this just now, keeping the dup comments
below :-) ).

> > v5 changes:
> >  4/8 - patch updated by Peter with actual format definitions
> >        for x86 processors
> >  6/8 - added hardcoded terms for config[12] and sample_period
> >        the code is ready to include branch_sample_type once
> >        this field is available in perf_event_attr, just
> >        uncommenting one line.. ;) 
> >      - allow config option to be used without value in which
> >        case 1 is assigned as value
> > 
> > Overall summarize:
> >  - adding event parser bison/flex generator
> >  - the event syntax stays as it was
> >  - adding event format sysfs group attribute
> >    for pmu device
> >  - adding new syntax to specify raw events based
> >    on the sysfs pmu's format attribute
> >    eg. "cpu/config=1,config1=2,config2=3/u"
> > 
> > Attached patches:
> >  1/8 perf, tool: Remove unused functions from debugfs object
> >  2/8 perf, tool: Add sysfs mountpoint interface
> >  3/8 perf, tool: Add bitmap_or function into bitmap object
> >  4/8 perf: Adding sysfs group format attribute for pmu device
> >  5/8 perf, tool: Add parser generator for events parsing
> >  6/8 perf, tool: Add config options support for event parsing
> >  7/8 perf, tool: Add perf pmu object to access pmu format definition
> >  8/8 perf, tool: Add support to specify pmu style event
> 
> I'm fine with this going fwd, and since this is mostly tools/perf I
> suggest acme take it, so:
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Also, it might make sense to CC everybody who has/maintains a hardware
> pmu implementation on patch 4.

I'll do it, I already merged patch 1, 2, 3 in my perf/core branch, will
look and merge the rest, adding your a-b.

- Arnaldo
