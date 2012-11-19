Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab2KSTBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 14:01:12 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49950 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab2KSTBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 14:01:10 -0500
Date: Mon, 19 Nov 2012 11:01:05 -0800
From: Tejun Heo <tj@kernel.org>
To: Daniel Wagner <daniel.wagner@bmw-carit.de>
Cc: serge.hallyn@canonical.com, ebiederm@xmission.com, nhorman@tuxdriver.com,
        tgraf@suug.ch, davem@davemloft.net, lizefan@huawei.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] netcls_cgroup: implement hierarchy
 support
Message-ID: <20121119190105.GL15971@htj.dyndns.org>
References: <1353123062-23193-1-git-send-email-tj@kernel.org>
 <50AA3B5E.3080701@bmw-carit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AA3B5E.3080701@bmw-carit.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Daniel.

On Mon, Nov 19, 2012 at 02:59:58PM +0100, Daniel Wagner wrote:
> Sorry to bring this up again: how should to root cgroup behave? If
> the ultimate goal to have only one single hierarchy then I would
> assume it is important that the semantic for all controllers are the
> same. As you pointed out the networking controllers are kind of a
> strange beast in the zoo of the cgroup controllers.  But still I
> would assume that all root controllers behave the same. memcg or
> cpu* are not expected to do any work in the root cgroup.

I think the implemented behavior is fine.  memcg or cpu* don't do
anything on root cgroup as it doesn't make much (or any) sense.  For
net_prio and cls, I don't see any reason to treat root cgroup
differently and how that would cause conflict when mounted together
with other controllers.  So, yeah, things seem okay to me.

Thanks.

-- 
tejun
