Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1F3SUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 14:20:21 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57969 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab1F3SUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 14:20:16 -0400
Date: Thu, 30 Jun 2011 11:19:51 -0700 (PDT)
Message-Id: <20110630.111951.1084304206576075172.davem@davemloft.net>
To: konrad.wilk@oracle.com
Cc: waldi@debian.org, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] xen/netback: Add module alias for autoloading
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110630163954.GE5771@dumpdata.com>
References: <20110629124132.GD31038@wavehammer.waldi.eu.org>
	<20110630163954.GE5771@dumpdata.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 30 Jun 2011 11:19:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 30 Jun 2011 12:39:54 -0400

> On Wed, Jun 29, 2011 at 02:41:32PM +0200, Bastian Blank wrote:
>> Add xen-backend:vif module alias to the xen-netback module. This allows
>> automatic loading of the module.
> 
> Dave,
> 
> Could you queue this up for 3.1 please? I've the other two patches in my
> tree for 3.1 and the block patch ready for Jens.

Done.
