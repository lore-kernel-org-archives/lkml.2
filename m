Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567Ab2F2QsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:48:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142Ab2F2QsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:48:06 -0400
Date: Fri, 29 Jun 2012 13:47:36 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Subject: Re: [PATCH 2/3] perf, tool: Enable grouping logic for parsed events
Message-ID: <20120629164736.GC7847@infradead.org>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
 <1340960907-3725-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340960907-3725-3-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 29, 2012 at 11:08:26AM +0200, Jiri Olsa escreveu:
> This patch adds a functionality that allows to create event groups
> based on the way they are specified on the command line. Adding
> functionality to the '{}' group syntax introduced in earlier patch.
> 
> The current '--group/-g' option behaviour remains intact.  If you
> specify it for record/stat/top command, all the specified events
> become members of a single group with the first event as a group
> leader.
> 
> With the new '{}' group syntax you can create group like:
>   # perf record -e '{cycles,faults}' ls

All this cset comment makes for great tools/perf/Documentation material,
right? Can you try and send a patch to add this to the 'record' man
page?

On top of these, that I'm merging/testing now.

- Arnaldo
