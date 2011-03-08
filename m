Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab1CHH2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 02:28:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:15490 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab1CHH2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 02:28:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,283,1297065600"; 
   d="scan'208";a="610258579"
Date: Mon, 7 Mar 2011 23:27:53 -0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Clark Williams <williams@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH V2] page-types.c: auto debugfs mount for hwpoison
 operation
Message-ID: <20110308072753.GA26747@localhost>
References: <1299487900-7792-1-git-send-email-gong.chen@linux.intel.com>
 <20110307184133.8A19.A69D9226@jp.fujitsu.com>
 <20110307113937.GB5080@localhost>
 <4D75B815.2080603@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D75B815.2080603@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 01:01:09PM +0800, Chen Gong wrote:
> page-types.c doesn't supply a way to specify the debugfs path and
> the original debugfs path is not usual on most machines. This patch
> supplies a way to auto mount debugfs if needed.
> 
> This patch is heavily inspired by tools/perf/utils/debugfs.c
> 
> Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
> ---
>   Documentation/vm/page-types.c |  105 
> +++++++++++++++++++++++++++++++++++++++--
>   1 files changed, 101 insertions(+), 4 deletions(-)

Thanks!

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
