Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab2GBKqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:46:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40779 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931Ab2GBKqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:46:47 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FF17B86.6090202@jp.fujitsu.com>
Date: Mon, 02 Jul 2012 19:44:22 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sha Zhengju <handai.szj@gmail.com>
CC: linux-mm@kvack.org, cgroups@vger.kernel.org, gthelen@google.com,
        yinghan@google.com, akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 2/7] memcg: remove MEMCG_NR_FILE_MAPPED
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com> <1340881111-5576-1-git-send-email-handai.szj@taobao.com>
In-Reply-To: <1340881111-5576-1-git-send-email-handai.szj@taobao.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/28 19:58), Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj@taobao.com>
> 
> While accounting memcg page stat, it's not worth to use MEMCG_NR_FILE_MAPPED
> as an extra layer of indirection because of the complexity and presumed
> performance overhead. We can use MEM_CGROUP_STAT_FILE_MAPPED directly.
> 
> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


