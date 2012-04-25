Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab2DYAbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 20:31:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60757 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab2DYAbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 20:31:18 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F97456B.5090201@jp.fujitsu.com>
Date: Wed, 25 Apr 2012 09:29:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 2/2] res_counter: Account max_usage when calling res_counter_charge_nofail()
References: <1335309096-12886-1-git-send-email-fweisbec@gmail.com> <1335309096-12886-3-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1335309096-12886-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/25 8:11), Frederic Weisbecker wrote:

> Updating max_usage is something one would expect when we reach
> a new maximum usage value even when we do this by forcing through
> the limit with res_counter_charge_nofail().
> 
> (Whether we want to account failcnt when we force through the limit
> is another debate).
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Glauber Costa <glommer@parallels.com>
> Cc: Kirill A. Shutemov <kirill@shutemov.name>


Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

