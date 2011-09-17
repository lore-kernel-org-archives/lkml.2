Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab1IQSLf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 14:11:35 -0400
Received: from shutemov.name ([188.40.19.243]:43784 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab1IQSLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 14:11:34 -0400
Date: Sat, 17 Sep 2011 21:11:32 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 4/7] per-cgroup tcp buffers control
Message-ID: <20110917181132.GC1658@shutemov.name>
References: <1316051175-17780-1-git-send-email-glommer@parallels.com>
 <1316051175-17780-5-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316051175-17780-5-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 10:46:12PM -0300, Glauber Costa wrote:
> +int tcp_init_cgroup_fill(struct proto *prot, struct cgroup *cgrp,
> +			 struct cgroup_subsys *ss)
> +{
> +	prot->enter_memory_pressure	= tcp_enter_memory_pressure;
> +	prot->memory_allocated		= memory_allocated_tcp;
> +	prot->prot_mem			= tcp_sysctl_mem;
> +	prot->sockets_allocated		= sockets_allocated_tcp;
> +	prot->memory_pressure		= memory_pressure_tcp;

No fancy formatting, please.

-- 
 Kirill A. Shutemov
