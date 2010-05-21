Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab0EUWHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 18:07:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33459
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752998Ab0EUWHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 18:07:08 -0400
Date: Fri, 21 May 2010 15:07:17 -0700 (PDT)
Message-Id: <20100521.150717.157502983.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: bug fix patch lost: git problem or just incorrect merge?
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.1005210931010.4243@i5.linux-foundation.org>
References: <1274456515.9022.14.camel@mulgrave.site>
	<alpine.LFD.2.00.1005210931010.4243@i5.linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 21 May 2010 09:45:49 -0700 (PDT)

> One of the reasons I ask people to let me merge is that it results in 
> cleaner history to not have criss-cross merges. And another is that I'm 
> pretty good at it, and letting me make merges also means that I am more 
> aware of problem spots.

That wasn't possible in this case.

This happened more than a week ago, as I needed to merge your tree into
net-2.6 to resolve a conflict there.  That's what took in the iscsi
bug fix, and this is way before the merge window.

Then I needed to pull net-2.6 into net-next-2.6 to resolve conflicts
existing between those two trees.

And this is why I ended up having to do the merge :-)

>> Either way, of course, we need the patch back ...
> 
> I'll fix it up.

Thanks Linus.
