Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab1IRU1M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 16:27:12 -0400
Received: from shutemov.name ([188.40.19.243]:46375 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718Ab1IRU1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 16:27:11 -0400
Date: Sun, 18 Sep 2011 23:27:10 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.osdl.org>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 09/11] cgroups: Add a task counter subsystem
Message-ID: <20110918202710.GE28057@shutemov.name>
References: <1315869091-18933-1-git-send-email-fweisbec@gmail.com>
 <1315869091-18933-10-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315869091-18933-10-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 01:11:29AM +0200, Frederic Weisbecker wrote:
> +static struct cftype files[] = {
> +	{
> +		.name		= "limit",
> +		.read_u64	= task_counter_read_u64,
> +		.write_u64	= task_counter_write_u64,
> +		.private	= RES_LIMIT,
> +	},
> +
> +	{
> +		.name		= "usage",
> +		.read_u64	= task_counter_read_u64,

It would be nice to implement .register_event/.unregister_event as well.

-- 
 Kirill A. Shutemov
