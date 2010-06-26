Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab0FZSMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 14:12:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab0FZSMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 14:12:47 -0400
Date: Sat, 26 Jun 2010 15:12:25 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>, mingo@elte.hu,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 2/3] perf: Remove dead code in buildin-record.c
Message-ID: <20100626181225.GD4078@ghostprotocols.net>
References: <4C241140.9090008@cn.fujitsu.com> <4C24119B.60200@cn.fujitsu.com> <20100625131356.GB4078@ghostprotocols.net> <1277477285.32034.666.camel@twins> <87pqzd3jx5.fsf@linux-g6p1.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pqzd3jx5.fsf@linux-g6p1.site>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Jun 26, 2010 at 04:14:46PM +0100, Matt Fleming escreveu:
> On Fri, 25 Jun 2010 16:48:05 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
> > Ah, yes, it would be nice for SH (which doesn't have a PMI) to couple a
> > software timer with their hardware counter to get samples.
> > 
> > Never got around to actually implementing that though, maybe Paul has a
> > minion interested in making that work?
> 
> I'll take a look at it.

Thanks!

- Arnaldo
