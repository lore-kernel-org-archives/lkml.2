Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423384Ab2KNTbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:31:23 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34882 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab2KNTbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:31:20 -0500
Date: Wed, 14 Nov 2012 14:18:12 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2012-11-09
Message-ID: <20121114191811.GD6128@tuxdriver.com>
References: <20121012110142.GF10739@joana>
 <20121110182427.GA7523@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121110182427.GA7523@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 07:24:27PM +0100, Gustavo Padovan wrote:
> Hi John,
> 
> A few important fixes to go into 3.7. There is a new hw support by Marcos
> Chaparro. Johan added a memory leak fix and hci device index list fix.
> Also Marcel fixed a race condition in the device set up that was prevent the
> bt monitor to work properly. Last, Paulo Sérgio added a fix to the error
> status when pairing for LE fails. This was prevent userspace to work to handle
> the failure properly.
> 
> Please pull! or let me know of any issues. Thanks.
> 
> 	Gustavo
> 
> ---
> The following changes since commit 6fe7cc71bbf3a0bc28c9cec3c00bc11e81344412:
> 
>   ath9k: Test for TID only in BlockAcks while checking tx status (2012-10-30 15:58:54 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master

Pulled...
 
> for you to fetch changes up to 482049f75750d73358e65236b933417b69f9cc25:
> 
>   Bluetooth: Fix memory leak when removing a UUID (2012-11-09 16:45:37 +0100)
> 
> ----------------------------------------------------------------
> Johan Hedberg (2):
>       Bluetooth: Fix having bogus entries in mgmt_read_index_list reply
>       Bluetooth: Fix memory leak when removing a UUID
> 
> Marcel Holtmann (1):
>       Bluetooth: Notify about device registration before power on
> 
> Marcos Chaparro (1):
>       Bluetooth: ath3k: Add support for VAIO VPCEH [0489:e027]
> 
> Paulo Sérgio (1):
>       Bluetooth: Fix error status when pairing fails
> 
>  drivers/bluetooth/ath3k.c |  1 +
>  drivers/bluetooth/btusb.c |  1 +
>  net/bluetooth/hci_core.c  |  4 ++--
>  net/bluetooth/mgmt.c      | 12 +++++++-----
>  net/bluetooth/smp.c       |  2 +-
>  5 files changed, 12 insertions(+), 8 deletions(-)
> 



-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
