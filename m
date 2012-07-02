Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab2GBKTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:19:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:33886 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938Ab2GBKTS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:19:18 -0400
Message-ID: <1341224342.23484.2.camel@twins>
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Date: Mon, 02 Jul 2012 12:19:02 +0200
In-Reply-To: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 11:08 +0200, Jiri Olsa wrote:
> hi,
> adding support for creating event groups based on the way they
> are specified on the command line.
> 
> This patchset adds the '{}' style grammar to express event group,
> allowing so far only the 'event modifier' as group modifier.
> 
> The sample/leader modifier changes are ready, but I'm getting
> some weird numbers in tests, so I'll send it later. Meanwhile,
> it'd be nice to have at least this patchset in.. ;)
> 
> 
> Attached patches:
>   1/3 perf, tool: Add support to parse event group syntax
>   2/3 perf, tool: Enable grouping logic for parsed events
>   3/3 perf, test: Add automated tests for event group parsing

Yeah, they look ok, thanks Jiri!
