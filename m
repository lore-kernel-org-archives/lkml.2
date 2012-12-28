Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2L1Aw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 19:52:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54407 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab2L1Aw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 19:52:56 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50DCED47.6030103@jp.fujitsu.com>
Date: Fri, 28 Dec 2012 09:52:23 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sha Zhengju <handai.szj@gmail.com>
CC: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, akpm@linux-foundation.org, gthelen@google.com,
        fengguang.wu@intel.com, glommer@parallels.com,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH V3 5/8] memcg: add per cgroup writeback pages accounting
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com> <1356456409-14701-1-git-send-email-handai.szj@taobao.com>
In-Reply-To: <1356456409-14701-1-git-send-email-handai.szj@taobao.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/12/26 2:26), Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj@taobao.com>
> 
> Similar to dirty page, we add per cgroup writeback pages accounting. The lock
> rule still is:
>          mem_cgroup_begin_update_page_stat()
>          modify page WRITEBACK stat
>          mem_cgroup_update_page_stat()
>          mem_cgroup_end_update_page_stat()
> 
> There're two writeback interface to modify: test_clear/set_page_writeback.
> 
> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


