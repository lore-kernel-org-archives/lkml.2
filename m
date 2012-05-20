Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab2ETVAk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 17:00:40 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60291 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab2ETVAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 17:00:38 -0400
Date: Sun, 20 May 2012 16:59:14 -0400 (EDT)
Message-Id: <20120520.165914.334514690365378881.davem@davemloft.net>
To: ajb@spheresystems.co.uk
Cc: bjorn@mork.no, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] USB: qmi_wwan: Make forced int 4 whitelist generic
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337502518-1444-1-git-send-email-ajb@spheresystems.co.uk>
References: <1337502518-1444-1-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 20 May 2012 13:59:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Bird <ajb@spheresystems.co.uk>
Date: Sun, 20 May 2012 09:28:36 +0100

> Change the forced interface 4 whitelist to use the generic shared
> binder instead of the Gobi specific one. Certain ZTE devices
> (K3520-Z & K3765-Z) don't work with the Gobi version, but function
> quite happily with the generic. This has been tested with the following
> devices:
> K3520-Z
> K3565-Z
> K3765-Z
> K4505-Z
> It hasn't been tested with the ZTE MF820D, which is the only other
> device that uses this whitelist at present. Although Bjorn doesn't
> expect any problems, any testing with that device would be appreciated.
> 
> Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>

Applied to net-next.
