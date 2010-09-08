Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab0IHAY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 20:24:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54760
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755429Ab0IHAYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 20:24:17 -0400
Date: Tue, 07 Sep 2010 17:24:34 -0700 (PDT)
Message-Id: <20100907.172434.28821101.davem@davemloft.net>
To: matt.causey@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Is via-velocity broken in 2.6.34?
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTin6RcDPFWpG4YBRF4O-8nrsA6e77K=knBA-uyf9@mail.gmail.com>
References: <AANLkTinK4VywsJ86jaC8wQjbXjzvP-z44JD3XbZbMM2a@mail.gmail.com>
	<20100907.163331.260082741.davem@davemloft.net>
	<AANLkTin6RcDPFWpG4YBRF4O-8nrsA6e77K=knBA-uyf9@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Causey <matt.causey@gmail.com>
Date: Tue, 7 Sep 2010 17:13:14 -0700

> So before I posted to the list, I actually dug through looking for
> recent changes which would be trivial for me to back out.  This was
> the only one I had found, so I tried it.  :-)  No luck though...same
> result.

Thanks, please continue reading up on how to bisect this down,
that will help us figure out what the problem is.

Thanks.
