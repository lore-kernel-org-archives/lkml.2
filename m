Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab2C2EkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 00:40:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34527 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2C2EkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 00:40:09 -0400
Date: Thu, 29 Mar 2012 00:40:02 -0400 (EDT)
Message-Id: <20120329.004002.1723417968924157530.davem@davemloft.net>
To: keithp@keithp.com
Cc: gustavo@padovan.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        johan.hedberg@intel.com
Subject: Re: [PATCH] Revert "Bluetooth: Always enable management interface"
From: David Miller <davem@davemloft.net>
In-Reply-To: <86r4wct9q7.fsf@sumi.keithp.com>
References: <1332983958-2734-1-git-send-email-keithp@keithp.com>
	<20120329022839.GA26111@joana>
	<86r4wct9q7.fsf@sumi.keithp.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 28 Mar 2012 21:40:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Packard <keithp@keithp.com>
Date: Wed, 28 Mar 2012 19:35:44 -0700

> <#part sign=pgpmime>
> On Wed, 28 Mar 2012 23:28:39 -0300, Gustavo Padovan <gustavo@padovan.org> wrote:
> 
>> A consequence is that you'll need to use newer version of bluez, at least 4.99.
>> Or call the bluetooth daemon (from a pre 4.99 version) with a parameter to
>> disable the new interface:
> 
> That's not OK -- you're breaking user space with this kernel change.

+1
