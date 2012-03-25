Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab2CYRaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 13:30:16 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50638 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab2CYRaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 13:30:14 -0400
Date: Sun, 25 Mar 2012 13:28:57 -0400 (EDT)
Message-Id: <20120325.132857.2007093851540454401.davem@davemloft.net>
To: ajb@spheresystems.co.uk
Cc: gregkh@linuxfoundation.org, smurf@smurf.noris.de,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Enable some ZTE modems to use the new QMI WWAN driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332670229-2045-1-git-send-email-ajb@spheresystems.co.uk>
References: <1332670229-2045-1-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 25 Mar 2012 10:28:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Bird <ajb@spheresystems.co.uk>
Date: Sun, 25 Mar 2012 11:10:26 +0100

> These patches enable the network devices on some Vodafone branded ZTE
> devices to be bound by the new QMI / WWAN driver. I suspect that the
> K3765-Z would also work, but at the moment I can't get the network
> interface to be recognised during probe.
> 
> (Reposted as previously I didn't cc netdev)

All applied, thanks.
