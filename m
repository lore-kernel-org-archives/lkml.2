Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab2EBGog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 02:44:36 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57281 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab2EBGoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 02:44:34 -0400
Date: Wed, 02 May 2012 02:44:27 -0400 (EDT)
Message-Id: <20120502.024427.22049954455309204.davem@davemloft.net>
To: mst@redhat.com
Cc: jasowang@redhat.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [V2 PATCH 0/9] vhost/macvtap zeropcopy fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120502055008.GA29319@redhat.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
	<20120502055008.GA29319@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 01 May 2012 23:44:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 2 May 2012 08:50:09 +0300

> On Wed, May 02, 2012 at 11:41:21AM +0800, Jason Wang wrote:
>> This is an updated since the last series of vhost/macvtap zerocopy fixes which
>> fixes the the possible transmission stall, host kernel stack overflow and other
>> misc fixes.
>> 
>> Changes from V1:
>> - Addressing comments from Eric and Michael.
>> - Adding more fixes into the seires.
> 
> Thanks for fixing this.
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Dave, can you merge this for 3.4 please?

It's rather late in the -RC for such a large patch set.
