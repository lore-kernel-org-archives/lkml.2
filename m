Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab1GOFh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 01:37:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:41836 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab1GOFhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 01:37:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,533,1304319600"; 
   d="scan'208";a="27508829"
Subject: Re: [PATCH] ftrace: Fix building warning with
 !CONFIG_FUNCTION_TRACER
From: Lin Ming <ming.m.lin@intel.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <CAM_iQpWrpY456YuHeR3QuLj_5FoFFgoOfNwGRqagwjiZKga7Gg@mail.gmail.com>
References: <1310707962.18875.349.camel@minggr.sh.intel.com>
	 <CAM_iQpWrpY456YuHeR3QuLj_5FoFFgoOfNwGRqagwjiZKga7Gg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 13:44:24 +0800
Message-ID: <1310708664.18875.351.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 13:30 +0800, Américo Wang wrote:
> On Fri, Jul 15, 2011 at 1:32 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> > Commit 43dd61c(ftrace: Fix regression of :mod:module function enabling)
> > causes below warning because ‘struct ftrace_hash’ is not declared with
> > !CONFIG_FUNCTION_TRACER.
> 
> It is fixed,
> https://lkml.org/lkml/2011/7/14/390

OK.

It's not in -tip yet, so I still see the warnings.

Thanks.


