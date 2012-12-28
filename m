Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab2L1BHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 20:07:23 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57043 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab2L1BHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 20:07:21 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50DCF0B1.4060000@jp.fujitsu.com>
Date: Fri, 28 Dec 2012 10:06:57 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sha Zhengju <handai.szj@gmail.com>
CC: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, akpm@linux-foundation.org, gthelen@google.com,
        fengguang.wu@intel.com, glommer@parallels.com,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH V3 7/8] memcg: disable memcg page stat accounting code
 when not in use
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com> <1356456477-14780-1-git-send-email-handai.szj@taobao.com>
In-Reply-To: <1356456477-14780-1-git-send-email-handai.szj@taobao.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/12/26 2:27), Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj@taobao.com>
> 
> It's inspired by a similar optimization from Glauber Costa
> (memcg: make it suck faster; https://lkml.org/lkml/2012/9/25/154).
> Here we use jump label to patch the memcg page stat accounting code
> in or out when not used. when the first non-root memcg comes to
> life the code is patching in otherwise it is out.
> 
> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


