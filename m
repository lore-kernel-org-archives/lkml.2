Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761094Ab2ILSP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:15:27 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50121 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761060Ab2ILSPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:15:21 -0400
Date: Wed, 12 Sep 2012 14:13:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2012-09-08
Message-ID: <20120912181309.GB28823@tuxdriver.com>
References: <20120908215956.GP5788@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120908215956.GP5788@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2012 at 06:59:56PM -0300, Gustavo Padovan wrote:
> Hi John,
> 
> A few more fixes to 3.6, here we have four important fix to the MGMT interface,
> two from Johan Hedberg and Andrzej Kaczmarek. Andrei fixed a free on
> uninitialized memory and I added support for Broadcom/Foxconn devices.

"Bluetooth: mgmt: Implement support for passkey notification" doesn't
look like a fix at all.

"Bluetooth: Update management interface revision" is suspect.  It kinda
makes sense, but if it is so important than it should have been merged
much earlier, no?

"Bluetooth: Add USB_VENDOR_AND_INTERFACE_INFO() for Broadcom/Foxconn"
might normally be OK, but it is getting late enough in the cycle
that I would prefer to delay any device ID patches until the next
merge window.

The others look fine.  Do you want me to merge them directly?
Or would you rather respin your pull request?

John

> Please pull, or let me know of any problems. Thanks.
> 
> 	Gustavo
> 
> The following changes since commit f10723841e624c0726c70356b31d91befed01dd6:
> 
>   libertas sdio: fix suspend when interface is down (2012-09-05 14:53:36 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master
> 
> for you to fetch changes up to b6f04c364ef853d8baa8949be20ef708000bcb97:
> 
>   Bluetooth: Fix freeing uninitialized delayed works (2012-09-08 17:27:52 -0300)
> 
> ----------------------------------------------------------------
> Andrei Emeltchenko (1):
>       Bluetooth: Fix freeing uninitialized delayed works
> 
> Andrzej Kaczmarek (2):
>       Bluetooth: mgmt: Fix enabling SSP while powered off
>       Bluetooth: mgmt: Fix enabling LE while powered off
> 
> Gustavo Padovan (1):
>       Bluetooth: Add USB_VENDOR_AND_INTERFACE_INFO() for Broadcom/Foxconn
> 
> Johan Hedberg (2):
>       Bluetooth: mgmt: Implement support for passkey notification
>       Bluetooth: Update management interface revision
> 
>  drivers/bluetooth/btusb.c        |  2 +-
>  include/net/bluetooth/hci.h      | 18 ++++++++++++
>  include/net/bluetooth/hci_core.h |  5 ++++
>  include/net/bluetooth/mgmt.h     |  7 +++++
>  net/bluetooth/hci_event.c        | 67 ++++++++++++++++++++++++++++++++++++++++++
>  net/bluetooth/l2cap_core.c       |  2 +-
>  net/bluetooth/mgmt.c             | 35 +++++++++++++++++++++-
>  7 files changed, 133 insertions(+), 3 deletions(-)
> 



-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
