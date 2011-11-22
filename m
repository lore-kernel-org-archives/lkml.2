Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457Ab1KVU7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:59:21 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53878 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1KVU7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:59:20 -0500
Date: Tue, 22 Nov 2011 15:58:53 -0500 (EST)
Message-Id: <20111122.155853.404208452350749584.davem@davemloft.net>
To: thomas@m3y3r.de
Cc: oliver@neukum.name, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CDC NCM: Use kzalloc rather than kmalloc followed by
 memset with 0
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321569820.1624.264.camel@localhost.localdomain>
References: <1321569820.1624.264.camel@localhost.localdomain>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 22 Nov 2011 12:58:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>
Date: Thu, 17 Nov 2011 23:43:40 +0100

> This considers some simple cases that are common and easy to validate
> Note in particular that there are no ...s in the rule, so all of the
> matched code has to be contiguous
> 
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/alloc/kzalloc-simple.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Applied.
