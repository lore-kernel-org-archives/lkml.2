Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab0FNANK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 20:13:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41725
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887Ab0FNANI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 20:13:08 -0400
Date: Sun, 13 Jun 2010 17:13:18 -0700 (PDT)
Message-Id: <20100613.171318.193707256.davem@davemloft.net>
To: john.r.fastabend@intel.com
Cc: markus@trippelsdorf.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, yanmin_zhang@linux.intel.com,
       alex.shi@intel.com, tim.c.chen@intel.com
Subject: Re: mpd client timeouts (bisected) 2.6.35-rc3
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C15414E.5090201@intel.com>
References: <20100612.145835.123986343.davem@davemloft.net>
	<4C149147.3080808@intel.com>
	<4C15414E.5090201@intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Fastabend <john.r.fastabend@intel.com>
Date: Sun, 13 Jun 2010 13:36:30 -0700

> Needed to set the wcard bit in copy_skb_header otherwise it will not
> be cleared when called from skb_clone.  Which then hits the loopback
> device gets pushed into the rx path and is eventually dropped. The
> following patch fixes this. Hopefully, this is easy and fast enough
> for you Dave.
> 
> 
> [PATCH] net: fix deliver_no_wcard regression on loopback device
> 
> deliver_no_wcard is not being set in skb_copy_header.
> In the skb_cloned case it is not being cleared and
> may cause the skb to be dropped when the loopback device
> pushes it back up the stack.
> 
> Signed-off-by: John Fastabend <john.r.fastabend@intel.com>

Applied, but your email client corrupted this patch in many
ways.  Please correct this for next time, thanks.
