Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1HVTed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 15:34:33 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46887 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab1HVTec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 15:34:32 -0400
Date: Mon, 22 Aug 2011 12:33:26 -0700 (PDT)
Message-Id: <20110822.123326.1795268471389412471.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-08-22
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110822190136.GJ2534@tuxdriver.com>
References: <20110822190136.GJ2534@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 22 Aug 2011 12:33:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 22 Aug 2011 15:01:37 -0400

> This is a batch of fixes intended for 3.1.  Included is rewrite of an
> earlier iwlagn fix that was revealed to be flawed (bad pointer access
> during module unload), a fix for a memory leak, and a trio of rt2x00
> fixes with detailed changelogs.  These have all been in linux-next
> for the last week with no reported complaints.
> 
> Please let me know if there are problems!

Pulled, thanks John.
