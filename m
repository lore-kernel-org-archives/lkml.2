Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab2DXKMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 06:12:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:41369 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab2DXKMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 06:12:07 -0400
Message-ID: <1335262311.28150.192.camel@twins>
Subject: Re: [RFC 1/2] kernel patch for dump user space stack tool
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Date: Tue, 24 Apr 2012 12:11:51 +0200
In-Reply-To: <1335231007.14538.71.camel@ymzhang.sh.intel.com>
References: <EE928378561BF1449699C96571234A740FCE3704@SHSMSX102.ccr.corp.intel.com>
	 <1334915073.2463.36.camel@laptop>
	 <1335231007.14538.71.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 09:30 +0800, Yanmin Zhang wrote:
> Would you like to point out the workable userspace stack walker?
> If there is, we would check if we could reuse it.
> 
> 
arch/x86/kernel/cpu/perf_event.c:perf_callchain_user(), it also deals
with compat stuffs.
