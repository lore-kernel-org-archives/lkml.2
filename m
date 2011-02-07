Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1BGOxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 09:53:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab1BGOxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 09:53:00 -0500
Date: Mon, 7 Feb 2011 12:52:04 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Borislav Petkov <bp@amd64.org>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        eranian@google.com, paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
        tzanussi@gmail.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [PATCH] perf annotate: Fix build error
Message-ID: <20110207145204.GB7651@ghostprotocols.net>
References: <new-submission> <tip-78f7defedbb4da73b9a07635c357c1afcaa55c8f@git.kernel.org> <20110207143218.GA31197@kryptos.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110207143218.GA31197@kryptos.osrc.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 07, 2011 at 03:32:18PM +0100, Borislav Petkov escreveu:
> On Mon, Feb 07, 2011 at 07:54:58AM +0000, tip-bot for Arnaldo Carvalho de Melo wrote:
> > Commit-ID:  78f7defedbb4da73b9a07635c357c1afcaa55c8f
> > Gitweb:     http://git.kernel.org/tip/78f7defedbb4da73b9a07635c357c1afcaa55c8f
> > Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
> > AuthorDate: Fri, 4 Feb 2011 09:45:46 -0200
> > Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> > CommitDate: Sat, 5 Feb 2011 12:28:21 -0200
> > 
> > perf annotate: Move annotate functions to util/
> 
> A small fix for when NO_NEWT_SUPPORT is defined.

Thanks, applying.

- Arnaldo
