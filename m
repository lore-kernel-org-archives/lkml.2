Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab2FKDEq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 23:04:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39375 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab2FKDEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 23:04:44 -0400
Date: Sun, 10 Jun 2012 20:04:43 -0700 (PDT)
Message-Id: <20120610.200443.971015025499077057.davem@davemloft.net>
To: levinsasha928@gmail.com
Cc: dbaryshkov@gmail.com, slapin@ossfans.org,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ieee802154: verify packet size before trying to
 allocate it
From: David Miller <davem@davemloft.net>
In-Reply-To: <1339326619-1753-1-git-send-email-levinsasha928@gmail.com>
References: <1339326619-1753-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <levinsasha928@gmail.com>
Date: Sun, 10 Jun 2012 13:10:19 +0200

> Currently when sending data over datagram, the send function will attempt to
> allocate any size passed on from the userspace.
> 
> We should make sure that this size is checked and limited. The maximum size
> of an IP packet seemed like the safest limit here.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Why not limit to the device MTU?  That's exactly what I suggested
to you.
