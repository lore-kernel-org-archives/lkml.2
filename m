Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0ILTCN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 15:02:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42380
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752072Ab0ILTCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 15:02:12 -0400
Date: Sun, 12 Sep 2010 12:02:30 -0700 (PDT)
Message-Id: <20100912.120230.71108625.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: ddutt@brocade.com, rmody@brocade.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: bna: potential null dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C8242CA.3020906@gmail.com>
References: <4C8242CA.3020906@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Sat, 04 Sep 2010 14:59:54 +0200

> stanse found a potential null dereference:
> bnad_cb_tx_cleanup
>   -> struct bnad_unmap_q *unmap_q = tcb->unmap_q;
>   -> -- tcb cannot be null now --
>   -> if (!tcb || (!tcb->unmap_q))
> 
> The thing is I have no idea whether the second parameter of cleanup may
> be null (move assignment after the check) or not (remove the check)
> 
> Could you fix that?

Since the Brocade folks can't be bothered to fix this for more than
a week I'll take care of this, thanks Jiri.
