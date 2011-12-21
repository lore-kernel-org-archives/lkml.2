Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1LUTkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:40:06 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54493 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1LUTkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:40:04 -0500
Date: Wed, 21 Dec 2011 14:38:57 -0500 (EST)
Message-Id: <20111221.143857.1290958187108678143.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-12-21
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111221185914.GD11842@tuxdriver.com>
References: <20111221185914.GD11842@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Dec 2011 11:39:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 21 Dec 2011 13:59:14 -0500

> A few last(?) fixes intended for 3.2...
> 
> The biggest portion are from Gustavo:
> 
> "3 fixes for 3.2! There one revert that was causing connection issues,
> a RFCOMM fix to a potential kernel panic, and the last on L2CAP to
> a possible access to uninitialized data due to broken remote devices."
> 
> Also, an iwlwifi fix for a problem causing firmware asserts.
> 
> Please let me know if there are problems!

Pulled, thanks John.
