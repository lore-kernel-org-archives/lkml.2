Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab2FODmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 23:42:13 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:1093 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab2FODmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 23:42:12 -0400
Message-ID: <4FDAAEB5.5050002@huawei.com>
Date: Fri, 15 Jun 2012 11:40:37 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Joe Perches <joe@perches.com>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: MAINTAINERS: missing git trees
References: <1339727661.25607.22.camel@joe2Laptop> <20120615025751.GB8250@localhost>
In-Reply-To: <20120615025751.GB8250@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.88.162]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/6/15 10:57, Fengguang Wu wrote:

> Hi Joe,
> 
> On Thu, Jun 14, 2012 at 07:34:21PM -0700, Joe Perches wrote:
>> These git trees listed in MAINTAINERS don't seem to exist.
> 
> Yeah I noticed this, too, several days ago.
> 
>> Should they be deleted?
> 
> Some trees are no longer exist (ie. netfilter), some are moved. For
> example, the btrfs tree is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
> 


There's already a patch sent to btrfs mailing list to update this.

> Perhaps it works best to notify the corresponding email addresses and
> ask for update patches. Then after some time, delete the remaining
> dead trees.


