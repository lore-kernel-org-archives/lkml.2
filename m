Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965457Ab1GOKxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 06:53:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41635 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965172Ab1GOKxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 06:53:11 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=4bmUdTBhvz4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=QyXUC8HyAAAA:8 a=D19gQVrFAAAA:8 a=aqOKIsZ-SrYTTsoPL78A:9 a=QEXdDO2ut3YA:10 a=dGJ0OcVc7YAA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] ftrace: Fix building warning with
 !CONFIG_FUNCTION_TRACER
From: Steven Rostedt <rostedt@goodmis.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1310708664.18875.351.camel@minggr.sh.intel.com>
References: <1310707962.18875.349.camel@minggr.sh.intel.com>
	 <CAM_iQpWrpY456YuHeR3QuLj_5FoFFgoOfNwGRqagwjiZKga7Gg@mail.gmail.com>
	 <1310708664.18875.351.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 06:53:08 -0400
Message-ID: <1310727188.27864.59.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 13:44 +0800, Lin Ming wrote:
> On Fri, 2011-07-15 at 13:30 +0800, Américo Wang wrote:
> > On Fri, Jul 15, 2011 at 1:32 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> > > Commit 43dd61c(ftrace: Fix regression of :mod:module function enabling)
> > > causes below warning because ‘struct ftrace_hash’ is not declared with
> > > !CONFIG_FUNCTION_TRACER.
> > 
> > It is fixed,
> > https://lkml.org/lkml/2011/7/14/390
> 
> OK.
> 
> It's not in -tip yet, so I still see the warnings.

Yeah, Ingo was the one to report it to me first, and I posted the fix
the next day. I also resent it last night as well.

-- Steve


