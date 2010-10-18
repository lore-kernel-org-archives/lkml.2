Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab0JRDDd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 23:03:33 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:57288 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751002Ab0JRDDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 23:03:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=rfTzCR8BKmLMKTkuDxxvIPO7g+haaDq2LvM7ANQsp2TM4+Eq11PLEGk0E7yTF3/3HSYp2+ViHr7Pc90r0T1z2pM3tJDtqu/qiCJQvd/QkfRUMXJH4SryIKY/FHW3d//l;
Date: Sun, 17 Oct 2010 20:02:46 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the pci tree
Message-ID: <20101017200246.195c8e9d@jbarnes-desktop>
In-Reply-To: <20101018132035.c506beff.sfr@canb.auug.org.au>
References: <20101018132035.c506beff.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 13:20:35 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jesse,
> 
> After merging the pci tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/pci/hotplug/pciehp_core.c: In function 'pcied_init':
> drivers/pci/hotplug/pciehp_core.c:348: error: implicit declaration of function 'alloc_ordered_workqueue'
> 
> That function is not declared anywhere except the (yet to be merged)
> workqueues tree.
> 
> I have used the pci tree from next-20101015 for today.
> 
> Please build test what you are exporting for merging into linux-next.

Arg, sorry about that, I'll drop these and just ack them for inclusion
by Tejun.

-- 
Jesse Barnes, Intel Open Source Technology Center
