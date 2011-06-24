Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab1FXUb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 16:31:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36894 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab1FXUb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 16:31:26 -0400
Date: Fri, 24 Jun 2011 13:30:18 -0700 (PDT)
Message-Id: <20110624.133018.633722812311589592.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-06-24
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110624184949.GC4793@tuxdriver.com>
References: <20110624184949.GC4793@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 24 Jun 2011 13:30:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 24 Jun 2011 14:49:49 -0400

> Dave,
> 
> Here is another batch of fixes intended for 3.0.  Included are too
> rtlwifi fixes from Larry:  a regression that broke firmware loading for
> rtl8292cu; and a fix to arbitrate between two devices that share the
> same PCI ID but are handled by different drivers...yeah.
> 
> The rest are Bluetooth fixes -- quoth Gustavo:
> 
> 	Three regressions fix intended for 3.0. Two of them fix a
> 	change made in our HCI security process for 3.0. The third
> 	one fixes an issue with non-SSP devices.  All of them are
> 	critical fixes. They should be in 3.0. Please pull!  Thanks.
> 
> Please let me know if there are problems!

Pulled, thanks!
