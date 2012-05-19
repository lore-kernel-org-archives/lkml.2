Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab2ESWsZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 18:48:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53160 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab2ESWsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 18:48:24 -0400
Date: Sat, 19 May 2012 18:48:12 -0400 (EDT)
Message-Id: <20120519.184812.2116650800791553287.davem@davemloft.net>
To: ajb@spheresystems.co.uk
Cc: oliver@neukum.name, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB CDC-Ether - Add ZTE WWAN matches before generic
 Ethernet
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337435767-9544-1-git-send-email-ajb@spheresystems.co.uk>
References: <1337435767-9544-1-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 19 May 2012 15:48:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Bird <ajb@spheresystems.co.uk>
Date: Sat, 19 May 2012 14:56:07 +0100

> Some ZTE WWAN devices have generic CDC Ether descriptors. Add those
> into the whitelist so that we get FLAG_WWAN on the interface
> 
> Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>

Applied.

But I changed the Subject line to have a more appropriate prefix,
namely "net: cdc_ether: "
