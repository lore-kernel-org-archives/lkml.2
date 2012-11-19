Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2KSTVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 14:21:49 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab2KSTVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 14:21:47 -0500
Date: Mon, 19 Nov 2012 11:21:42 -0800
From: Tejun Heo <tj@kernel.org>
To: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com,
        ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch
Cc: davem@davemloft.net, lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] netcls_cgroup: implement hierarchy
 support
Message-ID: <20121119192142.GM15971@htj.dyndns.org>
References: <1353123062-23193-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353123062-23193-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 07:30:59PM -0800, Tejun Heo wrote:
> Hello, guys.
> 
> This patchset implements proper hierarchy support for netcls_cgroup.
> Pretty simliar to the netprio one[3].  Simpler as each cgroup has
> single config value instead of array of them.

Applied to cgroup/for-3.8.

Thanks.

-- 
tejun
