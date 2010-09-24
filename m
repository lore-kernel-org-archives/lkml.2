Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab0IXXHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:07:36 -0400
Received: from mail.atheros.com ([12.19.149.2]:40545 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757490Ab0IXXHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:07:34 -0400
Date: Fri, 24 Sep 2010 16:07:31 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
CC: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
Subject: RFC: btusb firmware load help
Message-ID: <20100924230730.GB6566@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel, I was just poked about this thread:

http://www.spinics.net/lists/linux-bluetooth/msg06087.html

The hack is required because our BT hardware does not accept HCI commands
when the device is plugged in. If I understood your position you did not
want to accept the patch because our BT USB devices are violating the
specification by not acceping HCI commands and yet claiming to be BT
devices, is that right?

This position seems perfectly reasonable, and if it is violating the
specification this needs to be fixed in hardware for future devices. But
what is done is done, an dwe need to support existing customers with
current hardware, can you provide some recommendation as to an alternative
approach to resolve this upstream?

Without a patch like the one suggested Atheros' Bluetooth USB devices are
essentially not functional at all. I am in hopes we can come to some agreement
how to deal with a hardware quirk for now while we nag at our hardware team
to consider changing the way our devices work.

Someone from the Atheros BT team: can you send me the same patch to be
applied into compat-wireless under the linux-next-pending/ directory ?
That is, send me a patch which will apply onto compat-wireless.
This way we can actually get our hardware functional to customers while
we try to look for a better alternative directly upstream. You will
also need to document this issue on the wiki. I recommend you document
this here:

http://wireless.kernel.org/en/users/Drivers/ath3k

That is, create a new wiki page there for the driver and the things
needed for it. Once I get the patch into compat-wireless we can
refer users/customers to the compat-wireless stable releases with
the linux-next-pending/ patch you give to me applied.

Someone from the Atheros BT team: does the patch currently handle
suspend/resume?

  Luis
