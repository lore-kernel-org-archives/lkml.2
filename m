Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab1EZVbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 17:31:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767Ab1EZVbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 17:31:37 -0400
Date: Thu, 26 May 2011 18:30:58 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, eranian@google.com, tzanussi@gmail.com,
        penberg@cs.helsinki.fi, torvalds@linux-foundation.org, efault@gmx.de,
        peterz@infradead.org, davej@redhat.com, davem@davemloft.net,
        fweisbec@gmail.com, kees.cook@canonical.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf symbols: Handle
	/proc/sys/kernel/kptr_restrict
Message-ID: <20110526213058.GC30593@ghostprotocols.net>
References: <tip-mt512joaxxbhhp1odop04yit@git.kernel.org> <20110526193946.GA6363@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526193946.GA6363@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 26, 2011 at 09:39:46PM +0200, Ingo Molnar escreveu:
> 
> * tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> 
> > Commit-ID:  ec80fde746e3ccf93895d25ae1a7071c9af52585
> > Gitweb:     http://git.kernel.org/tip/ec80fde746e3ccf93895d25ae1a7071c9af52585
> > Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
> > AuthorDate: Thu, 26 May 2011 09:53:51 -0300
> > Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> > CommitDate: Thu, 26 May 2011 11:15:25 -0300
> > 
> > perf symbols: Handle /proc/sys/kernel/kptr_restrict
> 
> Ok, things are much better now with kptr_restrict turned on - but i 
> still see a few rough edges in practice.
> 
> For example 'perf top' says:
> 
>   aldebaran:~/linux> perf top
>   [kernel.kallsyms] with build id 122214021a666675f6e5ff97d70a85ce7139c0e7 not found, continuing without symbols
>   The (null) file can't be used
> 
> Now we've confused the user, havent we? :-)

The ones that do:

# echo -1 > /proc/sys/kernel/perf_event_paranoid

Right?

Trying that, not usually something I do :)

- Arnaldo
