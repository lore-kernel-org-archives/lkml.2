Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab0ILWhs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 18:37:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35420
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753892Ab0ILWhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 18:37:47 -0400
Date: Sun, 12 Sep 2010 15:38:05 -0700 (PDT)
Message-Id: <20100912.153805.226772440.davem@davemloft.net>
To: debdut@gmail.com
Cc: jirislaby@gmail.com, ddutt@brocade.com, rmody@brocade.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: bna: potential null dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTi=cZyLYJac8b8MsyAA4HitCvpD3NaH7nifzHDLw@mail.gmail.com>
References: <4C8242CA.3020906@gmail.com>
	<20100912.120230.71108625.davem@davemloft.net>
	<AANLkTi=cZyLYJac8b8MsyAA4HitCvpD3NaH7nifzHDLw@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Debashis Dutt <debdut@gmail.com>
Date: Sun, 12 Sep 2010 15:35:41 -0700

> A patch is on the way by tomorrow. BTW, this is just an unnecessary
> check that should be removed and not a NULL de-reference.

I've already made a fix in the net-next-2.6 tree.

You should send me fixes like this when you have them and are
reasonably confident of the change, which for something like
this should have been a day or two at most, not a week later.
