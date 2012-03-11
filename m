Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2CKWxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 18:53:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41902 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab2CKWxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 18:53:16 -0400
Date: Sun, 11 Mar 2012 15:53:08 -0700 (PDT)
Message-Id: <20120311.155308.854791460127462538.davem@davemloft.net>
To: j.neikes@midlandgate.de
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Patch for Sitecom LN-031
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331282643.5426.6.camel@mobile>
References: <1331282643.5426.6.camel@mobile>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 11 Mar 2012 15:53:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Neikes <j.neikes@midlandgate.de>
Date: Fri, 09 Mar 2012 09:44:03 +0100

> This patch adds support for the Sitecom LN-031 USB adapter with a AX88178 chip.
> 
> Added USB id to find correct driver for AX88178 1000 Ethernet adapter.
> 
> Signed-off-by: Joerg Neikes <j.neikes@midlandgate.de>

Applied, but please put more appropriate content in your subject
lines in the future.

You should, at a minimum, prefix the subject line with the driver or
subsystem name you are modifying.  In this case something like
"asix: " would have been appropriate.
