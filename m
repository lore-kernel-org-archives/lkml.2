Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026Ab0CPV2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:28:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41918
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754364Ab0CPV2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:28:04 -0400
Date: Tue, 16 Mar 2010 14:28:26 -0700 (PDT)
Message-Id: <20100316.142826.115796003.davem@davemloft.net>
To: jslaby@suse.cz
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Tristram.Ha@micrel.com
Subject: Re: [PATCH 1/1] NET: ksz884x, fix lock imbalance
From: David Miller <davem@davemloft.net>
In-Reply-To: <1268751230-14416-1-git-send-email-jslaby@suse.cz>
References: <1268751230-14416-1-git-send-email-jslaby@suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Tue, 16 Mar 2010 15:53:50 +0100

> Stanse found that one error path (when alloc_skb fails) in netdev_tx
> omits to unlock hw_priv->hwlock. Fix that.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Tristram Ha <Tristram.Ha@micrel.com>
> Cc: David S. Miller <davem@davemloft.net>

Applied, thanks.
