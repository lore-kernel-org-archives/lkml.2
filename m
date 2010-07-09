Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab0GIJ75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 05:59:57 -0400
Received: from smtp.nokia.com ([192.100.122.230]:63604 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab0GIJ7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 05:59:55 -0400
Subject: Re: linux-next: manual merge of the wireless tree with the net tree
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       David Miller <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <20100709115119.6c88f8d2.sfr@canb.auug.org.au>
References: <20100709115119.6c88f8d2.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 12:59:16 +0300
Message-ID: <1278669556.25296.1.camel@chilepepper>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jul 2010 09:59:21.0803 (UTC) FILETIME=[676869B0:01CB1F4D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, 2010-07-09 at 03:51 +0200, ext Stephen Rothwell wrote:
> Hi John,
> 
> Today's linux-next merge of the wireless tree got a conflict in
> drivers/net/wireless/wl12xx/wl1271_cmd.h between commit
> ba2d3587912f82d1ab4367975b1df460db60fb1e ("drivers/net: use __packed
> annotation") from the net tree and commit
> 34dd2aaac4a4b908c093980a9894fd878aeb6deb ("wl1271: moved scan operations
> to a separate file") from the wireless tree.
> 
> I didn't bother changing __attribute((packed)) to __packed where this
> code has been moved to.  Maybe someone could write a patch to do that ...

I'll submit a patch to change all the instances of __attribute((packed))
to __packed in the wl1271 driver.


-- 
Cheers,
Luca.

