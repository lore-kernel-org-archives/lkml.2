Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560Ab1FBI0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 04:26:11 -0400
Received: from mail.perches.com ([173.55.12.10]:2433 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab1FBI0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 04:26:09 -0400
Subject: Re: [PATCH 4/6] MAINTAINERS: Remove unused PERFORMANCE EVENTS
 pattern
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <20110602074057.GE2150@elte.hu>
References: <cover.1306950701.git.joe@perches.com>
	 <8d1e596980a6b6fec79432bb5a5953985cf85c2f.1306950701.git.joe@perches.com>
	 <20110602074057.GE2150@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 01:26:07 -0700
Message-ID: <1307003167.32125.59.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-02 at 09:40 +0200, Ingo Molnar wrote:
> * Joe Perches <joe@perches.com> wrote:
> > No arch/*/lib/perf_event* files exist so remove the pattern.
> The arch/*/lib/ hierarchy is a common place to put stuff into, it 
> does not hurt at all to have it mentioned.

Every once in awhile I run a script on MAINTAINERS
and fix up defects found by the script.

Dead code is dead code.
This was unused as of commit e360adbe2924.

> stop mucking with these patterns and start dealing 
> with some of the more important problems we have?

My time, my choice on what to do with it.

