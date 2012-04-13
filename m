Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2DMRms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:42:48 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51076 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab2DMRmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:42:46 -0400
Date: Fri, 13 Apr 2012 13:42:43 -0400 (EDT)
Message-Id: <20120413.134243.2000744517368456334.davem@davemloft.net>
To: fbl@redhat.com
Cc: jasowang@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8139cp: set intr mask after its handler is registered
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120412104529.27ece685@asterix.rh>
References: <20120412081053.25774.41676.stgit@amd-6168-8-1.englab.nay.redhat.com>
	<20120412104529.27ece685@asterix.rh>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 Apr 2012 10:42:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Flavio Leitner <fbl@redhat.com>
Date: Thu, 12 Apr 2012 10:45:29 -0300

> On Thu, 12 Apr 2012 16:10:54 +0800
> Jason Wang <jasowang@redhat.com> wrote:
> 
>> We set intr mask before its handler is registered, this does not work well when
>> 8139cp is sharing irq line with other devices. As the irq could be enabled by
>> the device before 8139cp's hander is registered which may lead unhandled
>> irq. Fix this by introducing an helper cp_irq_enable() and call it after
>> request_irq().
>> 
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> Reviewed-by: Flavio Leitner <fbl@redhat.com>

Applied, and queued up for -stable, thanks.
