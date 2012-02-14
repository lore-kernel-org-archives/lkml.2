Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239Ab2BNTqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 14:46:32 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:48589 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab2BNTq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 14:46:29 -0500
Date: Tue, 14 Feb 2012 14:46:22 -0500 (EST)
Message-Id: <20120214.144622.678577766818888054.davem@davemloft.net>
To: toby.gray@realvnc.com
Cc: oliver@neukum.name, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] usb: cdc-ncm: Increase maximum allowed datagram
 size
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329230375-25508-1-git-send-email-toby.gray@realvnc.com>
References: <1329230375-25508-1-git-send-email-toby.gray@realvnc.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 14 Feb 2012 11:46:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toby Gray <toby.gray@realvnc.com>
Date: Tue, 14 Feb 2012 14:39:35 +0000

> Some NCM devices exist which will send datagrams larger than 2k and
> don't support the GetMaxDatagramSize request, such as the Nokia 701
> Mobile Telephone.
> 
> This sets the maximum limit of datagrams to the theoretical limit for
> 16-bit NTBs, preventing dropping of large datagrams received from some
> devices.
> 
> Signed-off-by: Toby Gray <toby.gray@realvnc.com>

Can a USB expert please sanity check this before I apply it?

Thanks.
