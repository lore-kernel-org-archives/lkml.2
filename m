Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0FXHVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 03:21:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47213 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab0FXHVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 03:21:47 -0400
Subject: Re: [PATCH v2] perf: close the opened directories.
From: Peter Zijlstra <peterz@infradead.org>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, acme@ghostprotocols.net,
       mingo@elte.hu, linux kernel mailing list <linux-kernel@vger.kernel.org>,
       paulus@samba.org
In-Reply-To: <4C230362.5080704@cn.fujitsu.com>
References: <4C1C3F7C.4030607@cn.fujitsu.com>
	 <1277360965.2096.881.camel@ymzhang.sh.intel.com>
	 <4C230362.5080704@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 09:21:34 +0200
Message-ID: <1277364094.1875.848.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 15:04 +0800, Gui Jianfeng wrote:
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

Looks good to me, Arnaldo, will you pick this up?
