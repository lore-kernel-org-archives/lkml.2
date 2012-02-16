Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab2BPRDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 12:03:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39972 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab2BPRDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 12:03:23 -0500
Message-ID: <1329411783.2293.257.camel@twins>
Subject: Re: [PATCHv5 0/8] perf tool: parser generator for events parsing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Date: Thu, 16 Feb 2012 18:03:03 +0100
In-Reply-To: <1329393652-6055-1-git-send-email-jolsa@redhat.com>
References: <1329393652-6055-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 13:00 +0100, Jiri Olsa wrote:
> hi,
> here's new version of event parsing patchset.
> 
> I saw Arnaldo already sent patches 1-3 to Ingo, but they did not make it
> to the tree yet, so I'm still attaching them here.
> 
> v5 changes:
>  4/8 - patch updated by Peter with actual format definitions
>        for x86 processors
>  6/8 - added hardcoded terms for config[12] and sample_period
>        the code is ready to include branch_sample_type once
>        this field is available in perf_event_attr, just
>        uncommenting one line.. ;) 
>      - allow config option to be used without value in which
>        case 1 is assigned as value
> 
> Overall summarize:
>  - adding event parser bison/flex generator
>  - the event syntax stays as it was
>  - adding event format sysfs group attribute
>    for pmu device
>  - adding new syntax to specify raw events based
>    on the sysfs pmu's format attribute
>    eg. "cpu/config=1,config1=2,config2=3/u"
> 
> Attached patches:
>  1/8 perf, tool: Remove unused functions from debugfs object
>  2/8 perf, tool: Add sysfs mountpoint interface
>  3/8 perf, tool: Add bitmap_or function into bitmap object
>  4/8 perf: Adding sysfs group format attribute for pmu device
>  5/8 perf, tool: Add parser generator for events parsing
>  6/8 perf, tool: Add config options support for event parsing
>  7/8 perf, tool: Add perf pmu object to access pmu format definition
>  8/8 perf, tool: Add support to specify pmu style event

I'm fine with this going fwd, and since this is mostly tools/perf I
suggest acme take it, so:

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Also, it might make sense to CC everybody who has/maintains a hardware
pmu implementation on patch 4.

Thanks Jiri!
