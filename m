Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab0HHGBi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 02:01:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40844
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864Ab0HHGBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 02:01:37 -0400
Date: Sat, 07 Aug 2010 23:01:56 -0700 (PDT)
Message-Id: <20100807.230156.25112206.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, gospo@redhat.com,
        bphilips@novell.com
Subject: Re: [PATCH 2/2] igbvf.txt: Add igbvf Documentation
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100804001615.6571.69837.stgit@localhost.localdomain>
References: <20100804001429.6571.95116.stgit@localhost.localdomain>
	<20100804001615.6571.69837.stgit@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 03 Aug 2010 17:16:17 -0700

> Adds documentation for the igbvf (igb virtual function driver).
> 
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Tested-by: Jeff Pieper <jeffrey.e.pieper@intel.com>

Tons of trailing whitespace, GIT nearly craps itself when I try
to apply this.

Please fix this, and also submit the fixed up 1/1 ixgbe.txt doc patch
and even more importantly the ixgbe FCOE build fix you promised I'd
have two nights ago :-)

Thanks.
