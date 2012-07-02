Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab2GBKIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:08:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932850Ab2GBKIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:08:02 -0400
Date: Mon, 2 Jul 2012 12:07:36 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
Message-ID: <20120702100736.GA967@krava.redhat.com>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
 <4FF10693.5000907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF10693.5000907@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 08:25:23PM -0600, David Ahern wrote:
> Hi Jiri:
> 
> On 6/29/12 3:08 AM, Jiri Olsa wrote:
> >hi,
> >adding support for creating event groups based on the way they
> >are specified on the command line.
> >
> >This patchset adds the '{}' style grammar to express event group,
> >allowing so far only the 'event modifier' as group modifier.
> >
> >The sample/leader modifier changes are ready, but I'm getting
> >some weird numbers in tests, so I'll send it later. Meanwhile,
> >it'd be nice to have at least this patchset in.. ;)
> >
> >
> >Attached patches:
> >   1/3 perf, tool: Add support to parse event group syntax
> >   2/3 perf, tool: Enable grouping logic for parsed events
> >   3/3 perf, test: Add automated tests for event group parsing
> 
> Would you mind updating perf-stat and perf-record Documentation to
> include the group option?

yes, Arnaldo already stressed that.. ;) I'll send it
with my next patchset

jirka

> 
> David
