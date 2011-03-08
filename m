Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1CHGIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 01:08:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47934 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1CHGIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 01:08:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Chen Gong <gong.chen@linux.intel.com>
Subject: Re: [PATCH V2] page-types.c: auto debugfs mount for hwpoison operation
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Clark Williams <williams@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
In-Reply-To: <4D75B815.2080603@linux.intel.com>
References: <20110307113937.GB5080@localhost> <4D75B815.2080603@linux.intel.com>
Message-Id: <20110308150824.7EC2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Mar 2011 15:08:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


Cute!
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



