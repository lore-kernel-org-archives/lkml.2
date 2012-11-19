Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab2KSTSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 14:18:38 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:50583 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab2KSTSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 14:18:37 -0500
Message-ID: <50AA860B.9040804@monom.org>
Date: Mon, 19 Nov 2012 20:18:35 +0100
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com,
        ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch,
        davem@davemloft.net, lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] netcls_cgroup: introduce cgroup_cls_state->is_local
References: <1353123062-23193-1-git-send-email-tj@kernel.org> <1353123062-23193-3-git-send-email-tj@kernel.org> <20121119173026.GJ15971@htj.dyndns.org>
In-Reply-To: <20121119173026.GJ15971@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 19.11.2012 18:30, Tejun Heo wrote:
> cs->is_local will be used to indicate whether the cgroup has its own
> configuration or inherited from the parent.  It's set when classid is
> configured by writing a positive value to cgroup file
> "net_cls.classid" and cleared when a negative value is written.
>
> is_local is visible to userland via cgroup file "net_cls.is_local" so
> that userland can know whether a cgroup has its config or not.
>
> This patch doesn't yet change hierarchy behavior.  The next patch will
> use is_local to implement proper hierarchy.
>
> v2: Daniel pointed out that cftype->write_u64() accepts base prefix
>      (e.g. 0x10 for 16).  Updated "%lld" to "%lli".
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: David S. Miller <davem@davemloft.net>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Cc: Daniel Wagner <wagi@monom.org>

Acked-by: Daniel Wagner <daniel.wagner@bmw-carit.de>

thanks,
daniel

