Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1KDCp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 22:45:59 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49556 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab1KDCp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 22:45:58 -0400
Date: Thu, 03 Nov 2011 22:45:51 -0400 (EDT)
Message-Id: <20111103.224551.824371140351083319.davem@davemloft.net>
To: ricardo.ribalda@gmail.com
Cc: ian.campbell@citrix.com, eric.dumazet@gmail.com,
        jeffrey.t.kirsher@intel.com, jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ll_temac: Add support for phy_mii_ioctl
From: David Miller <davem@davemloft.net>
In-Reply-To: <1320239646-15377-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1320239646-15377-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 03 Nov 2011 19:45:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed,  2 Nov 2011 14:14:06 +0100

> This patch enables the ioctl support for the driver. So userspace
> programs like mii-tool can work.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Please submit such feature additions when the net-next tree opens back up.
