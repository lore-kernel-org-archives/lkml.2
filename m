Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124Ab2CTIsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:48:33 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:53860 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab2CTIsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:48:31 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>, glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 07/10] cgroup: remove cgroup_add_file[s]()
In-Reply-To: <1331940963-15756-8-git-send-email-tj@kernel.org>
References: <1331940963-15756-1-git-send-email-tj@kernel.org> <1331940963-15756-8-git-send-email-tj@kernel.org>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 20 Mar 2012 14:17:51 +0530
Message-ID: <87aa3bu094.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12031922-7014-0000-0000-000000C088D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> No controller is using cgroup_add_files[s]().  Unexport them, and
> convert cgroup_add_files() to handle NULL entry terminated array
> instead of taking count explicitly and continue creation on failure
> for internal use.
>

I am planning to use that in the HugeTLB extension of memcg.

http://article.gmane.org/gmane.linux.kernel.mm/75470

We need to have different limit and usage file for different HugeTLB
page size supported.

-aneesh

