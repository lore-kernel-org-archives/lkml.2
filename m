Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab2K3EMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 23:12:52 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60023 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab2K3EMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 23:12:51 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50B8322D.7050104@jp.fujitsu.com>
Date: Fri, 30 Nov 2012 13:12:29 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch v2 6/6] cgroup: remove css_get_next
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz> <1353955671-14385-7-git-send-email-mhocko@suse.cz>
In-Reply-To: <1353955671-14385-7-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/27 3:47), Michal Hocko wrote:
> Now that we have generic and well ordered cgroup tree walkers there is
> no need to keep css_get_next in the place.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Hm, then, the next think will be css_is_ancestor() etc..

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


