Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab1KHURD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 15:17:03 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46439 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab1KHURB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 15:17:01 -0500
Date: Tue, 08 Nov 2011 15:16:50 -0500 (EST)
Message-Id: <20111108.151650.2211132862241211917.davem@davemloft.net>
To: ricardo.ribalda@gmail.com
Cc: ian.campbell@citrix.com, eric.dumazet@gmail.com,
        jeffrey.t.kirsher@intel.com, jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND] ll_temac: Add support for phy_mii_ioctl
From: David Miller <davem@davemloft.net>
In-Reply-To: <1320745665-11688-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1320745665-11688-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 08 Nov 2011 12:16:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue,  8 Nov 2011 10:47:45 +0100

> This patch enables the ioctl support for the driver. So userspace
> programs like mii-tool can work.
> 
> Resend in merge window
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Applied.
