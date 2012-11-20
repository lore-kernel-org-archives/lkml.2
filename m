Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2KTHUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:20:24 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:34910 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab2KTHUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:20:22 -0500
Date: Mon, 19 Nov 2012 23:20:17 -0800
From: Tejun Heo <tj@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com,
        ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch,
        lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET v2 cgroup/for-3.8] netcls/prio_cgroup: update
 hierarchy support
Message-ID: <20121120072017.GH25790@mtj.dyndns.org>
References: <1353395190-4530-1-git-send-email-tj@kernel.org>
 <20121120.021826.1608846012970947300.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120.021826.1608846012970947300.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

On Tue, Nov 20, 2012 at 02:18:26AM -0500, David Miller wrote:
> Tejun, I would really appreciate it if you would CC: netdev on
> networking patches so that other networking developers can review
> these changes too.

Ah, sorry about that.  Wasn't really thinking which subsystem (other
than cgroup) these two belong to.  Will do so from now on, or would it
be better to repost them w/ netdev added?

Thanks.

-- 
tejun
