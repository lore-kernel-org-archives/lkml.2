Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab2C2ElN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 00:41:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34540 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2C2ElB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 00:41:01 -0400
Date: Thu, 29 Mar 2012 00:40:56 -0400 (EDT)
Message-Id: <20120329.004056.1415897384263124663.davem@davemloft.net>
To: gustavo@padovan.org
Cc: keithp@keithp.com, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        johan.hedberg@intel.com
Subject: Re: [PATCH] Revert "Bluetooth: Always enable management interface"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120329022839.GA26111@joana>
References: <1332983958-2734-1-git-send-email-keithp@keithp.com>
	<20120329022839.GA26111@joana>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 28 Mar 2012 21:40:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gustavo Padovan <gustavo@padovan.org>
Date: Wed, 28 Mar 2012 23:28:39 -0300

> A consequence is that you'll need to use newer version of bluez, at
> least 4.99.

That's complete bullshit and you know it.

Existing userspace worked, you guys broke it with a kernel change.

Therefore the kernel change needs to be reverted.
