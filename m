Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab1IWOLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:11:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab1IWOLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:11:37 -0400
Date: Fri, 23 Sep 2011 11:11:13 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, anton@samba.org,
        Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        ak@linux.intel.com, Robert Richter <robert.richter@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/4] perf symbols: /proc/kallsyms does not sort module
	symbols
Message-ID: <20110923141113.GA27519@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBR5ie5yJAB1xTCfQoZroFZWna42=iptmB_Cwt3hCuyQ=w@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 23, 2011 at 03:59:33PM +0200, Stephane Eranian escreveu:
> Hi,
> 
> What's the status of this patch?
> 
> It is not in 3.1.0-rc7. It is needed!
> 
> I ran into serious issues (bogus symbols) with a profile where
> kernel modules were stressed and it boiled down to kallsyms__parse()
> being broken because /proc/kallsyms is assumed sorted when it actually
> is NOT.

Its all here:

https://github.com/acmel/linux/commits/perf/urgent

I was waiting for Ingo, Peter, can you take a look and see if you agree
with the patches there then I can ask Linus to pull it, ok?

- Arnaldo
