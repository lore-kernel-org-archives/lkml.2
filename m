Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965924Ab0GPPmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 11:42:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50532 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965872Ab0GPPml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 11:42:41 -0400
Date: Fri, 16 Jul 2010 12:42:21 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, mingo@elte.hu,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH v2] perf: close the opened directories.
Message-ID: <20100716154221.GB4051@ghostprotocols.net>
References: <4C1C3F7C.4030607@cn.fujitsu.com>
 <1277360965.2096.881.camel@ymzhang.sh.intel.com>
 <4C230362.5080704@cn.fujitsu.com>
 <20100624135227.GA4784@ghostprotocols.net>
 <4C400C23.5070102@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C400C23.5070102@cn.fujitsu.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jul 16, 2010 at 03:37:07PM +0800, Gui Jianfeng escreveu:
> Arnaldo Carvalho de Melo wrote:
> > Em Thu, Jun 24, 2010 at 03:04:02PM +0800, Gui Jianfeng escreveu:
> >> When I ran "perf kvm ... top", I encountered the following error output.
> >>
> >>   Error: perfcounter syscall returned with -1 (Too many open files)
> >>
> >>   Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
> >>
> >> Looking into perf, I found perf opens too many direcotries at initialization
> >> time, but forgets to close them. Here is the fix.
> >>
> >> Signef-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> > 
> > Thanks, will apply.
> 
> Hi Arnaldo,
> 
> Would you pick up this fix?

It was already, no? Nope, I thought about that other one about . and ..,
will apply.

- Arnaldo
