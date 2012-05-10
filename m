Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473Ab2EJSzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:55:23 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53433 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760308Ab2EJSzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:55:21 -0400
Date: Thu, 10 May 2012 14:55:10 -0400 (EDT)
Message-Id: <20120510.145510.1040533529305157641.davem@davemloft.net>
To: alexander.h.duyck@intel.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        stephen.s.ko@intel.com, jeffrey.t.kirsher@intel.com
Subject: Re: [ 33/52] net: Fix issue with netdev_tx_reset_queue not
 resetting queue from XOFF state
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FAC0EA7.3000100@intel.com>
References: <20120510173135.772550373@linuxfoundation.org>
	<4FAC0EA7.3000100@intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 11:55:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@intel.com>
Date: Thu, 10 May 2012 11:53:27 -0700

> All of the changes in igb are unnecessary.  I think they can be dropped
> from the patch as they have already been reverted from the latest
> net-next.  The only change that is really needed is the piece in
> netdevice.h below.

Does it hurt?  If not, just let it be.
