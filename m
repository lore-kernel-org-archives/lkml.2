Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2FGUKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:10:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45378 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab2FGUKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:10:37 -0400
Date: Thu, 07 Jun 2012 13:10:36 -0700 (PDT)
Message-Id: <20120607.131036.454649403537424443.davem@davemloft.net>
To: levinsasha928@gmail.com
Cc: dbaryshkov@gmail.com, slapin@ossfans.org,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ieee802154: verify packet size before trying to
 allocate it
From: David Miller <davem@davemloft.net>
In-Reply-To: <1339018322-19360-1-git-send-email-levinsasha928@gmail.com>
References: <1339018322-19360-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed,  6 Jun 2012 23:32:02 +0200

> Currently when sending data over datagram, the send function will attempt to
> allocate any size passed on from the userspace.
> 
> We should make sure that this size is checked and limited. The maximum size
> of an IP packet seemed like the safest limit here.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

This limit is arbitrary, I'm not applying a patch like this.

Use the actual limit, which is either the protocol limit or something
like the device mtu.
