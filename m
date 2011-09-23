Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab1IWONB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:13:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39667 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab1IWONA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:13:00 -0400
Subject: Re: [PATCH 2/4] perf symbols: /proc/kallsyms does not sort module
 symbols
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        anton@samba.org, mingo@elte.hu, ak@linux.intel.com,
        Robert Richter <robert.richter@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Sep 2011 16:12:29 +0200
In-Reply-To: <20110923141113.GA27519@ghostprotocols.net>
References: <20110923141113.GA27519@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316787149.9084.43.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 11:11 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Sep 23, 2011 at 03:59:33PM +0200, Stephane Eranian escreveu:
> > Hi,
> > 
> > What's the status of this patch?
> > 
> > It is not in 3.1.0-rc7. It is needed!
> > 
> > I ran into serious issues (bogus symbols) with a profile where
> > kernel modules were stressed and it boiled down to kallsyms__parse()
> > being broken because /proc/kallsyms is assumed sorted when it actually
> > is NOT.
> 
> Its all here:
> 
> https://github.com/acmel/linux/commits/perf/urgent
> 
> I was waiting for Ingo, Peter, can you take a look and see if you agree
> with the patches there then I can ask Linus to pull it, ok?

Looks all-right, ship it! :-)
