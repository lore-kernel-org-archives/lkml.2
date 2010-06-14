Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab0FNAOc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 20:14:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41731
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754919Ab0FNAOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 20:14:30 -0400
Date: Sun, 13 Jun 2010 17:14:42 -0700 (PDT)
Message-Id: <20100613.171442.226776182.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: john.r.fastabend@intel.com, markus@trippelsdorf.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       yanmin_zhang@linux.intel.com, alex.shi@intel.com, tim.c.chen@intel.com
Subject: Re: mpd client timeouts (bisected) 2.6.35-rc3
From: David Miller <davem@davemloft.net>
In-Reply-To: <1276462246.2448.17.camel@edumazet-laptop>
References: <4C149147.3080808@intel.com>
	<4C15414E.5090201@intel.com>
	<1276462246.2448.17.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sun, 13 Jun 2010 22:50:46 +0200

> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Eric, please never ACK a patch in the same mail in which you are
posting new patch.  Patchwork won't add your ACK to the patchwork
entry you are ACK'ing because all of your text will go into a new
patchwork entry for the patch you are posting.

> BTW, David, it seems there is a double rxhash copy...
> 
> [PATCH] net: rxhash already set in __copy_skb_header
> 
> No need to copy rxhash again in __skb_clone()
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

I'll apply this, thanks.
