Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab1KROOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 09:14:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757913Ab1KROOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 09:14:33 -0500
Date: Fri, 18 Nov 2011 12:14:16 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH] perf tool: Refactoring IO data files code
Message-ID: <20111118141416.GA13052@ghostprotocols.net>
References: <1321624005-6889-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321624005-6889-1-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 18, 2011 at 02:46:40PM +0100, Jiri Olsa escreveu:
> Hi,
> 
> based on following discussion:
> http://marc.info/?l=linux-kernel&m=131731212425421&w=2
> http://marc.info/?l=linux-kernel&m=131736842010972&w=2
> 
> I made some changes to have event memory mapping and input/output
> data code in one place. The reason was to make the change for
> multiple event data files at least possible ;)
> 
> This patchset is marked as RFC since it's quite big change
> and I expect some better design might come up.
> 
> However, patches 1 and 2 are not big deal, since they are
> just small (not so related) changes.
> 
> Patches 3-4 are the main change of the patchset.
> 
> 1/5 perf tool: Fix session host_nachine retrieval
> 2/5 perf tool: Initialize events IDs in a single function
> 3/5 perf tool: Introducing perf_mmap object
> 4/5 perf tool: Introducing perf_data object
> 5/5 perf tool: Putting mmap support to perf_data object

Reading those patches now.
 
> I did some overall testing of all the changed command,
> and so far so good. Just hit issue with 'diff' command,
> but this one seems not to work even without my changes.

Yeah, it needs more work to properly suport multi-event perf.data files.
 
> Also the current perf python binsing code is broken
> wit missing dependencies so I could not test my
> changes there.

Which ones? I fixed some and posted to my perf/urgent branch, waiting
for Ingo to merge.

- Arnaldo
