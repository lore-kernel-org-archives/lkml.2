Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab1GGLIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 07:08:51 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41514 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab1GGLIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 07:08:49 -0400
Date: Thu, 07 Jul 2011 04:08:40 -0700 (PDT)
Message-Id: <20110707.040840.809661052978541081.davem@davemloft.net>
To: mashirle@us.ibm.com
Cc: mst@redhat.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V8 0/4 net-next] macvtap/vhost TX zero-copy support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1309990525.10209.12.camel@localhost.localdomain>
References: <1309990525.10209.12.camel@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 07 Jul 2011 04:08:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shirley Ma <mashirle@us.ibm.com>
Date: Wed, 06 Jul 2011 15:15:25 -0700

> This patchset add supports for TX zero-copy between guest and host
> kernel through vhost. It significantly reduces CPU utilization on the
> local host on which the guest is located (It reduced about 50% CPU usage
> for single stream test on the host, while 4K message size BW has
> increased about 50%). The patchset is based on previous submission and
> comments from the community regarding when/how to handle guest kernel
> buffers to be released. This is the simplest approach I can think of
> after comparing with several other solutions.
> 
> This patchset has integrated V3 review comments from community: 

I'm personally fine with this patch set.  Unless there are others
who object, please fix the use-after-free bug I reported, respin
the patch set, and I'll apply it.

Thanks.
