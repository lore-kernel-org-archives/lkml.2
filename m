Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab2BQImK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 03:42:10 -0500
Received: from senator.holtmann.net ([87.106.208.187]:37036 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab2BQImH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 03:42:07 -0500
Message-ID: <1329468126.28848.135.camel@aeonflux>
Subject: Re: [PATCH V2 3/3] bluetooth: Convert BT_DBG to pr_debug
From: Marcel Holtmann <marcel@holtmann.org>
To: Joe Perches <joe@perches.com>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Fri, 17 Feb 2012 09:42:06 +0100
In-Reply-To: <6e53178ca0d6ca35c4953e653571d03379759af5.1329461203.git.joe@perches.com>
References: <cover.1329461202.git.joe@perches.com>
	 <6e53178ca0d6ca35c4953e653571d03379759af5.1329461203.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

> Add "\n" to uses, align arguments, coalesce formats.
> Fix a typo and fix a bad format extended by a line continuation.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/bluetooth/ath3k.c       |   10 +-
>  drivers/bluetooth/bcm203x.c     |   10 +-
>  drivers/bluetooth/bfusb.c       |   35 +++---
>  drivers/bluetooth/bpa10x.c      |   30 ++--
>  drivers/bluetooth/btmrvl_main.c |   63 +++++-----
>  drivers/bluetooth/btmrvl_sdio.c |   27 ++--
>  drivers/bluetooth/btsdio.c      |   24 ++--
>  drivers/bluetooth/btusb.c       |   48 ++++----
>  drivers/bluetooth/btwilink.c    |   17 +--
>  drivers/bluetooth/hci_ath.c     |    8 +-
>  drivers/bluetooth/hci_bcsp.c    |   28 ++--
>  drivers/bluetooth/hci_h4.c      |   10 +-
>  drivers/bluetooth/hci_ldisc.c   |   23 ++--
>  drivers/bluetooth/hci_ll.c      |   50 ++++----
>  include/net/bluetooth/l2cap.h   |    2 +-
>  net/bluetooth/af_bluetooth.c    |   16 +-
>  net/bluetooth/bnep/core.c       |   26 ++--
>  net/bluetooth/bnep/netdev.c     |   12 +-
>  net/bluetooth/bnep/sock.c       |    6 +-
>  net/bluetooth/cmtp/capi.c       |   31 +++--
>  net/bluetooth/cmtp/core.c       |   23 ++--
>  net/bluetooth/cmtp/sock.c       |    6 +-
>  net/bluetooth/hci_conn.c        |   58 ++++----
>  net/bluetooth/hci_core.c        |  151 +++++++++++----------
>  net/bluetooth/hci_event.c       |  282 ++++++++++++++++++++-------------------
>  net/bluetooth/hci_sock.c        |   20 ++--
>  net/bluetooth/hci_sysfs.c       |    8 +-
>  net/bluetooth/hidp/core.c       |   44 ++++---
>  net/bluetooth/hidp/sock.c       |    6 +-
>  net/bluetooth/l2cap_core.c      |  189 ++++++++++++++-------------
>  net/bluetooth/l2cap_sock.c      |   34 +++---
>  net/bluetooth/mgmt.c            |   89 ++++++------
>  net/bluetooth/rfcomm/core.c     |  164 ++++++++++++-----------
>  net/bluetooth/rfcomm/sock.c     |   49 ++++----
>  net/bluetooth/rfcomm/tty.c      |   88 ++++++------
>  net/bluetooth/sco.c             |   69 +++++-----
>  net/bluetooth/smp.c             |   33 +++---
>  37 files changed, 915 insertions(+), 874 deletions(-)

this one has to wait. You are disturbing multiple developers that are
working on core features.

Regards

Marcel


