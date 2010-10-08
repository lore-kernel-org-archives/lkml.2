Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094Ab0JHRiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:38:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35892
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205Ab0JHRiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:38:20 -0400
Date: Fri, 08 Oct 2010 10:38:42 -0700 (PDT)
Message-Id: <20101008.103842.39184623.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-10-07
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101007185859.GD20950@tuxdriver.com>
References: <20101007185859.GD20950@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 7 Oct 2010 14:58:59 -0400

> Here are a few more more-or-less-one-liner fixes intended for 2.6.36.
> The one from Felix fixes a regression introduced in the 2.6.36 cycle.
> The one from Johannes fixes a crash reported by Ben Greear (as
> documented in the changelog).  The one from me reverts and earlier patch
> from me that can result in stuff in dmesg from not calling
> netif_receive_skb in the proper context.

Pulled, thanks John.
