Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab0FXNxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 09:53:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:33586 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab0FXNxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 09:53:09 -0400
Date: Thu, 24 Jun 2010 10:52:27 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, mingo@elte.hu,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH v2] perf: close the opened directories.
Message-ID: <20100624135227.GA4784@ghostprotocols.net>
References: <4C1C3F7C.4030607@cn.fujitsu.com>
 <1277360965.2096.881.camel@ymzhang.sh.intel.com>
 <4C230362.5080704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C230362.5080704@cn.fujitsu.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 24, 2010 at 03:04:02PM +0800, Gui Jianfeng escreveu:
> When I ran "perf kvm ... top", I encountered the following error output.
> 
>   Error: perfcounter syscall returned with -1 (Too many open files)
> 
>   Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
> 
> Looking into perf, I found perf opens too many direcotries at initialization
> time, but forgets to close them. Here is the fix.
> 
> Signef-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

Thanks, will apply.

- Arnaldo
