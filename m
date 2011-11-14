Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1KNFbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 00:31:04 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46074 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1KNFbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 00:31:02 -0500
Date: Mon, 14 Nov 2011 00:30:48 -0500 (EST)
Message-Id: <20111114.003048.2051399548192848039.davem@davemloft.net>
To: mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jcliburn@gmail.com,
        chris.snook@gmail.com
Subject: Re: [PATCH V2 1/6] net/ethernet/atl1c: Disable ASPM on various
 chipsets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321028064-644-2-git-send-email-mjg@redhat.com>
References: <1321028064-644-1-git-send-email-mjg@redhat.com>
	<1321028064-644-2-git-send-email-mjg@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 13 Nov 2011 21:31:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>
Date: Fri, 11 Nov 2011 11:14:19 -0500

> The Windows driver disables ASPM support for various chipsets supported
> by atl1c. This adds the same set of logic to the Linux driver. ASPM is
> disabled on l1c, l2c, l2cb and l2cb2 devices except for those in Toshiba
> or Lenovo devices. Data taken from
> http://www.atheros.cz/atheros-inf-file.php?inf=199&chipset=51&system=6
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Applied.
