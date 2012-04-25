Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549Ab2DYAak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 20:30:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60957 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757610Ab2DYAaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 20:30:39 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F974545.1060107@jp.fujitsu.com>
Date: Wed, 25 Apr 2012 09:28:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 1/2] res_counter: Merge res_counter_charge and res_counter_charge_nofail
References: <1335309096-12886-1-git-send-email-fweisbec@gmail.com> <1335309096-12886-2-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1335309096-12886-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/25 8:11), Frederic Weisbecker wrote:

> These two functions do almost the same thing and duplicate some code.
> Merge their implementation into a single common function.
> res_counter_charge_locked() takes one more parameter but it doesn't seem
> to be used outside res_counter.c yet anyway.
> 
> There is no (intended) change in the behaviour.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Glauber Costa <glommer@parallels.com>
> Cc: Kirill A. Shutemov <kirill@shutemov.name>


Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

