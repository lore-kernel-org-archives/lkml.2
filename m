Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1DDJI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:08:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36351
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016Ab1DDJI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:08:26 -0400
Date: Mon, 04 Apr 2011 02:07:48 -0700 (PDT)
Message-Id: <20110404.020748.212408124.davem@davemloft.net>
To: ian.campbell@citrix.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        xen-devel@lists.xensource.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] MAINTAINERS: add entry for Xen network backend
From: David Miller <davem@davemloft.net>
In-Reply-To: <1301905567-7880-1-git-send-email-ian.campbell@citrix.com>
References: <1301905567-7880-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>
Date: Mon,  4 Apr 2011 09:26:07 +0100

> +XEN NETWORK BACKEND DRIVER
> +M:	Ian Campbell <ian.campbell@citrix.com>
> +L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
> +S:	Supported
> +F:	drivers/net/xen-netback/*
> +

To me there isn't much reason to have patch and other discussions
about a network driver on a moderated XEN list (which the majority of
core network developers are not subscribed to).

If anything, list both.  But not listing netdev is pretty pointless.
