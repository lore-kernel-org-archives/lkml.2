Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab2GBKPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:15:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932909Ab2GBKPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:15:37 -0400
Date: Mon, 2 Jul 2012 12:15:18 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
Message-ID: <20120702101518.GC967@krava.redhat.com>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
 <87fw9blyhj.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fw9blyhj.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 10:53:44AM +0900, Namhyung Kim wrote:
> Hi, Jiri
> 
> On Fri, 29 Jun 2012 11:08:24 +0200, Jiri Olsa wrote:
> > hi,
> > adding support for creating event groups based on the way they
> > are specified on the command line.
> >
> > This patchset adds the '{}' style grammar to express event group,
> > allowing so far only the 'event modifier' as group modifier.
> >
> > The sample/leader modifier changes are ready, but I'm getting
> > some weird numbers in tests, so I'll send it later. Meanwhile,
> > it'd be nice to have at least this patchset in.. ;)
> >
> 
> Just a question, is there a way to know about the grouping at perf
> report time?

nope, AFAIK only ID and perf_event_attr is stored for event
grouping is known only for record time

jirka
