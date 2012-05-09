Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591Ab2EIRY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:24:26 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53081 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab2EIRYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:24:23 -0400
Date: Wed, 9 May 2012 14:16:59 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] perf record: fix fallback to cpu-clock on ppc
Message-ID: <20120509171659.GQ2485@infradead.org>
References: <1336452004-55724-1-git-send-email-dsahern@gmail.com>
 <20120509145619.GM2485@infradead.org>
 <4FAA99D5.9090404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAA99D5.9090404@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, May 09, 2012 at 10:22:45AM -0600, David Ahern escreveu:
> On 5/9/12 8:56 AM, Arnaldo Carvalho de Melo wrote:
> >Em Mon, May 07, 2012 at 10:40:04PM -0600, David Ahern escreveu:
> >>perf-record on PPC is not falling back to cpu-clock:

> >Thanks, applied to my perf/core branch.

> >Can you please provide one for perf/urgent?

> Not needed. Problem on perf/core was introduced by
> 5a7ed29c7572d00a75e8c4529e30c5ac2ef82271

> The perf-stat version is needed and applies cleanly (though with an
> offset) to perf/urgent.

Ok, git cherry-pick worked on it, pushing perf/urgent out with it.

- Arnaldo
