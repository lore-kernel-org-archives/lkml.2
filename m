Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab1FCXyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 19:54:44 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58665 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab1FCXyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 19:54:43 -0400
Date: Fri, 03 Jun 2011 16:53:37 -0700 (PDT)
Message-Id: <20110603.165337.468496746139098019.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-06-03
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110603195254.GF2509@tuxdriver.com>
References: <20110603195254.GF2509@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 03 Jun 2011 16:53:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 3 Jun 2011 15:52:54 -0400

> Here is a batch of fixes intended for 3.0 -- I guess I'll need to
> rename my tree eventually... :-)
> 
> Included are a libertas fix to ensure proper sequence number assignment
> on transmitted frames, an ath9k fix that propogates an earlier fix to a
> few more places,  a fix for a cfg80211 regression caused by some mesh
> code changes, a locking fix for the bluetooth l2cap code, a zd1211rw
> regression fix, a collection of small fixes for wl12xx, an iwl4965
> fix for a bad temperature check, an a device ID-related fix for iwlagn.
> 
> Please let me know if there are problems!

Pulled, thanks John.
