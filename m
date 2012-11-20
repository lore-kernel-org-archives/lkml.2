Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab2KTPN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:13:29 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51467 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab2KTPN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:13:27 -0500
Date: Tue, 20 Nov 2012 07:13:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Daniel Wagner <wagi@monom.org>
Cc: serge.hallyn@canonical.com, ebiederm@xmission.com, nhorman@tuxdriver.com,
        tgraf@suug.ch, davem@davemloft.net, lizefan@huawei.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/7] netprio_cgroup: reimplement priomap expansion
Message-ID: <20121120151322.GR15971@htj.dyndns.org>
References: <1353400211-5182-1-git-send-email-tj@kernel.org>
 <1353400211-5182-5-git-send-email-tj@kernel.org>
 <50AB435E.8060901@monom.org>
 <20121120143832.GO15971@htj.dyndns.org>
 <50AB9D22.5030000@monom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AB9D22.5030000@monom.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 20, 2012 at 04:09:22PM +0100, Daniel Wagner wrote:
> Thanks for the explanation. I was pondering if the new size in power
> of two could be a bit too excessive and the allocation step could be
> linear, e.g. stick at 4096. target_id will increase linear,
> therefore linear increase might also be enough, no?

Well, power-of-two resizing tends to behave relatively well under most
cases and slab allocations are binned by power-of-two sizes, so
linearly growing it doesn't really buy anything.

Thanks.

-- 
tejun
