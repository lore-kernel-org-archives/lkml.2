Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab2IRTS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 15:18:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab2IRTSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 15:18:55 -0400
Message-ID: <5058C91A.1030303@gmail.com>
Date: Tue, 18 Sep 2012 13:18:50 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Dong Hao <haodong@linux.vnet.ibm.com>
CC: acme@infradead.org, mtosatti@redhat.com, avi@redhat.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com
Subject: Re: [PATCH v8 2/3] perf: move stat related code to util/stat.c
References: <1347870675-31495-1-git-send-email-haodong@linux.vnet.ibm.com> <1347870675-31495-3-git-send-email-haodong@linux.vnet.ibm.com>
In-Reply-To: <1347870675-31495-3-git-send-email-haodong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/12 2:31 AM, Dong Hao wrote:
> From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>
> Then, the code can be shared between kvm events and perf stat
>
> [ Dong Hao <haodong@linux.vnet.ibm.com>: rebase it on acme's git tree ]
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> Signed-off-by: Dong Hao <haodong@linux.vnet.ibm.com>
> ---
>   tools/perf/Makefile       |    1 +
>   tools/perf/builtin-stat.c |   56 +------------------------------------------
>   tools/perf/util/stat.c    |   57 +++++++++++++++++++++++++++++++++++++++++++++
>   tools/perf/util/stat.h    |   16 ++++++++++++
>   4 files changed, 76 insertions(+), 54 deletions(-)
>   create mode 100644 tools/perf/util/stat.c
>   create mode 100644 tools/perf/util/stat.h

Does not apply to Arnaldo's latest perf/core branch.

David

