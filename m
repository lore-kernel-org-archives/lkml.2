Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab0DZSUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 14:20:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44973
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752865Ab0DZSUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 14:20:52 -0400
Date: Mon, 26 Apr 2010 11:20:56 -0700 (PDT)
Message-Id: <20100426.112056.48506797.davem@davemloft.net>
To: dbaryshkov@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefan@datenfreihafen.org
Subject: Re: [PATCH] ieee802154: Fix oops during ieee802154_sock_ioctl
From: David Miller <davem@davemloft.net>
In-Reply-To: <1272293202-11712-1-git-send-email-dbaryshkov@gmail.com>
References: <1272293202-11712-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Date: Mon, 26 Apr 2010 18:46:42 +0400

> From: Stefan Schmidt <stefan@datenfreihafen.org>
> 
> Trying to run izlisten (from lowpan-tools tests) on a device that does not
> exists I got the oops below. The problem is that we are using get_dev_by_name
> without checking if we really get a device back. We don't in this case and
> writing to dev->type generates this oops.
> 
> [Oops code removed by Dmitry Eremin-Solenikov]
> 
> If possible this patch should be applied to the current -rc fixes branch.
> 
> Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

Applied, and queued up for -stable too, thanks guys.
