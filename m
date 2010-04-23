Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab0DWHpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 03:45:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54067 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756276Ab0DWHpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 03:45:49 -0400
Message-ID: <4BD14FEE.1090407@cn.fujitsu.com>
Date: Fri, 23 Apr 2010 15:44:46 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Divyesh Shah <dpshah@google.com>, Nauman Rafique <nauman@google.com>
Subject: Re: [PATCH] blk-cgroup: config options re-arrangement
References: <20100422223705.GI3228@redhat.com>
In-Reply-To: <20100422223705.GI3228@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> This patch fixes few usability and configurability issues.
> 
> o All the cgroup based controller options are configurable from
>   "Genral Setup/Control Group Support/" menu. blkio is the only exception.
>   Hence make this option visible in above menu and make it configurable from
>   there to bring it inline with rest of the cgroup based controllers.
> 
> o Get rid of CONFIG_DEBUG_CFQ_IOSCHED.
> 
>   This option currently does two things.
> 
>   - Enable printing of cgroup paths in blktrace
>   - Enables CONFIG_DEBUG_BLK_CGROUP, which in turn displays additional stat
>     files in cgroup.
> 
>   If we are using group scheduling, blktrace data is of not really much use
>   if cgroup information is not present. To get this data, currently one has to
>   also enable CONFIG_DEBUG_CFQ_IOSCHED, which in turn brings the overhead of
>   all the additional debug stat files which is not desired.
> 
>   Hence, this patch moves printing of cgroup paths under
>   CONFIG_CFQ_GROUP_IOSCHED.
> 
>   This allows us to get rid of CONFIG_DEBUG_CFQ_IOSCHED completely. Now all
>   the debug stat files are controlled only by CONFIG_DEBUG_BLK_CGROUP which
>   can be enabled through config menu.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

This patch looks good to me.

Reviewed-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

