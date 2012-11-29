Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab2K2MVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 07:21:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab2K2MVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 07:21:53 -0500
Date: Thu, 29 Nov 2012 13:21:20 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 00/18] perf report: Add support for event group view (v6)
Message-ID: <20121129122120.GF1096@krava.brq.redhat.com>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
 <1354171126-14387-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354171126-14387-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 03:38:28PM +0900, Namhyung Kim wrote:
> Hi all,
> 
> This is my 6th iteration of event group view patchset.
> For basic idea and usage example, please see my original post [1].
> 
> The largest change in this version is using 'pairs' list of hist_entry
> instead of allocating group_stats for all group members.  But I needed
> to allocate temporary arrays for internal purpose anyway.  If you have
> a better solution please let me know.
> 
> Jiri, sorry for the delay, I had to hunt down some nasty bugs in my
> patches.  And I saw you submitted the multiplu diff series which will
> conflict my changes.  I'll have a look at it soon, and I'd be glad if
> you take a look at my changes too. :)

np, great.. will do ;)

thanks,
jirka
