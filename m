Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab2GIGuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:50:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53352 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab2GIGuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:50:05 -0400
Date: Sun, 08 Jul 2012 23:50:05 -0700 (PDT)
Message-Id: <20120708.235005.1770661412478433472.davem@davemloft.net>
To: levinsasha928@gmail.com
Cc: dbaryshkov@gmail.com, slapin@ossfans.org,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ieee802154: verify packet size before trying to
 allocate it
From: David Miller <davem@davemloft.net>
In-Reply-To: <1341228595-9883-1-git-send-email-levinsasha928@gmail.com>
References: <1341228595-9883-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon,  2 Jul 2012 13:29:55 +0200

> Currently when sending data over datagram, the send function will attempt to
> allocate any size passed on from the userspace.
> 
> We should make sure that this size is checked and limited. We'll limit it
> to the MTU of the device, which is checked later anyway.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Applied.
