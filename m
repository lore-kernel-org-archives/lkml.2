Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab2GTJdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 05:33:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab2GTJdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 05:33:47 -0400
Date: Fri, 20 Jul 2012 11:33:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Subject: Re: [PATCHv4 0/4] perf tool: Add new event group management
Message-ID: <20120720093317.GA3566@krava.redhat.com>
References: <1342734837-1825-1-git-send-email-jolsa@redhat.com>
 <87629i3lc2.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87629i3lc2.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 05:09:33PM +0900, Namhyung Kim wrote:
> Hi, Jiri
> 
> On Thu, 19 Jul 2012 23:53:53 +0200, Jiri Olsa wrote:
> > hi,
> > adding support for creating event groups based on the way they
> > are specified on the command line.
> >
> > This patchset adds the '{}' style grammar to express event group,
> > allowing so far only the 'event modifier' as group modifier.
> >
> > v4 changes:
> >   - group modifier updates events modifiers (not overwrite as in v3)
> >
> > Attached patches:
> >   perf, tool: Add support to parse event group syntax
> >   perf, tool: Add support to update event modifier
> >   perf, tool: Enable grouping logic for parsed events
> >   perf, test: Add automated tests for event group parsing
> >
> 
> Thanks for keeping working on this. You can add my
> 
>   Reviewed-by: Namhyung Kim <namhyung@kernel.org>
> 
> for all of the patches if you want.
> 

great, thanks!

> Btw, is it all of your user-space changes?

I have changes for the group leader sampling, which needs more testing..
also maybe some redo after I saw your hist changes.. ;)

jirka
