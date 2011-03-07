Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab1CGLkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:40:25 -0500
Received: from mga14.intel.com ([143.182.124.37]:12428 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab1CGLkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:40:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,276,1297065600"; 
   d="scan'208";a="398693807"
Date: Mon, 7 Mar 2011 19:39:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Chen Gong <gong.chen@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Clark Williams <williams@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH] page-types.c: add a new argument of debugfs path
Message-ID: <20110307113937.GB5080@localhost>
References: <1299487900-7792-1-git-send-email-gong.chen@linux.intel.com>
 <20110307184133.8A19.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307184133.8A19.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 05:42:39PM +0800, KOSAKI Motohiro wrote:
> > page-types.c doesn't supply a way to specify the debugfs path and
> > the original debugfs path is not usual on most machines. Add a
> > new argument to set the debugfs path easily.
> > 
> > Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
> 
> Hi
> 
> Why do we need to set debugfs path manually? Instead I'd suggested to
> read /proc/mount and detect it automatically.

Good idea! And could reuse tools/perf/util/debugfs.c for finding out
and even audo-mounting debugfs. 

Thanks,
Fengguang
