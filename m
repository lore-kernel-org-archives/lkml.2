Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab2ETVAx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 17:00:53 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60299 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab2ETVAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 17:00:51 -0400
Date: Sun, 20 May 2012 16:59:36 -0400 (EDT)
Message-Id: <20120520.165936.1796496403682068067.davem@davemloft.net>
To: ajb@spheresystems.co.uk
Cc: bjorn@mork.no, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] USB: qmi_wwan: Add ZTE (Vodafone) K3765-Z
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337502518-1444-2-git-send-email-ajb@spheresystems.co.uk>
References: <1337502518-1444-1-git-send-email-ajb@spheresystems.co.uk>
	<1337502518-1444-2-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 20 May 2012 13:59:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Bird <ajb@spheresystems.co.uk>
Date: Sun, 20 May 2012 09:28:37 +0100

> Add the ZTE (Vodafone) K3765-Z to the whitelist. This requires the
> previous patch to make the whitelist with forced interface 4 generic
> or the device fails to initialise. After applying this patch and
> loading the Option driver without usb-modeswitch's bind all
> interfaces trick, a wwan0 net interface and /dev/cdc-wdm0 device
> file were created. Using Bjorn Mork's perl connection script a
> connection was made to a mobile network using QMI and the network
> interface's IPv4 address was configured OK.
> 
> Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>

Applied to net-next.
