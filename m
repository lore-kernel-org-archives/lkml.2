Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab0E2GBx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 02:01:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40645
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751230Ab0E2GBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 02:01:49 -0400
Date: Fri, 28 May 2010 23:01:58 -0700 (PDT)
Message-Id: <20100528.230158.191386259.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-05-28
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100528180952.GC2405@tuxdriver.com>
References: <20100528180952.GC2405@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 28 May 2010 14:09:53 -0400

> Here are a few small fixes intended for 2.6.35.  Included are a null
> pointer dereference fix, and a use-after-free fix, as well as some more
> minor stuff.  It also include the revert of a earlier patch that I
> inadvertantly merged out of order, effectively creating a bug rather
> than fixing one.  The reverted patch will now be pointed at 2.6.36
> instead.
> 
> Please let me know if there are problems!

Pulled, thanks John.
