Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab2C2EkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 00:40:07 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34522 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2C2EkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 00:40:03 -0400
Date: Thu, 29 Mar 2012 00:39:50 -0400 (EDT)
Message-Id: <20120329.003950.997517954860580620.davem@davemloft.net>
To: marcel@holtmann.org
Cc: keithp@keithp.com, gustavo@padovan.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, johan.hedberg@intel.com
Subject: Re: [PATCH] Revert "Bluetooth: Always enable management interface"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332992022.1870.183.camel@aeonflux>
References: <20120329022839.GA26111@joana>
	<86r4wct9q7.fsf@sumi.keithp.com>
	<1332992022.1870.183.camel@aeonflux>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 28 Mar 2012 21:39:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Thu, 29 Mar 2012 05:33:42 +0200

> I think we actually have a broken user space in this case. I do have a
> hunch on what went wrong. It is not the kernel's fault here.

I call bullshit.

It doesn't matter what userspace is doing, "broken" or however you
want to call it.  The bluez on everyone's computer broke because of
the kernel change.

Therefore you must revert the kernel change or modify it so that
existing userland continues to work properly.

There is no other proper course of action.

And to think, I gave you bluetooth guys shit because of coding style
problems, that appears to have been just the tip of the iceberg.
