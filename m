Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab0FZPOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 11:14:48 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:55557 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478Ab0FZPOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 11:14:47 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>, mingo@elte.hu,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/3] perf: Remove dead code in buildin-record.c
In-Reply-To: <1277477285.32034.666.camel@twins>
References: <4C241140.9090008@cn.fujitsu.com> <4C24119B.60200@cn.fujitsu.com>  <20100625131356.GB4078@ghostprotocols.net> <1277477285.32034.666.camel@twins>
User-Agent: Notmuch/0.3.1-61-g3f63bb6 (http://notmuchmail.org) Emacs/23.1.90.2 (x86_64-unknown-linux-gnu)
Date: Sat, 26 Jun 2010 16:14:46 +0100
Message-ID: <87pqzd3jx5.fsf@linux-g6p1.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010 16:48:05 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> Ah, yes, it would be nice for SH (which doesn't have a PMI) to couple a
> software timer with their hardware counter to get samples.
> 
> Never got around to actually implementing that though, maybe Paul has a
> minion interested in making that work?

I'll take a look at it.
