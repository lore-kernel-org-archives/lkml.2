Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab1KIUkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:40:17 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:38873 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab1KIUkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:40:16 -0500
Date: Wed, 09 Nov 2011 15:40:06 -0500 (EST)
Message-Id: <20111109.154006.436356200830517997.davem@davemloft.net>
To: ricardo.ribalda@gmail.com
Cc: ian.campbell@citrix.com, eric.dumazet@gmail.com,
        jeffrey.t.kirsher@intel.com, jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ll_temac: FIX : Wait for indirect wait to end
From: David Miller <davem@davemloft.net>
In-Reply-To: <1320745197-11053-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1320745197-11053-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 09 Nov 2011 12:40:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue,  8 Nov 2011 10:39:57 +0100

> While tracing down a connectivity problem on the temac I connected a
> probe to the Cross bar irq, and it was triggered when doing
> ifdown->ifup.
> 
> This is fixed once waiting for the indirect write to end. Since it is
> not on the hot path there is no performance loss.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Also applied, thanks.
