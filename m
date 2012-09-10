Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab2IJGRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 02:17:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48742 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2IJGRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 02:17:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120909224155.647306922@decadent.org.uk>
References: <20120909224150.641491654@decadent.org.uk>
	<20120909224155.647306922@decadent.org.uk>
Date: Mon, 10 Sep 2012 08:17:06 +0200
Message-ID: <CA+rthh8Z8panzcLT9baQd=qEvywfJcQVk1wCnHJ_PCBu=Rn5Tw@mail.gmail.com>
Subject: Re: [ 35/95] dccp: check ccid before dereferencing
From: Mathias Krause <minipli@googlemail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Mon, Sep 10, 2012 at 12:42 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.

No objections, but could you please consider including the following
commits, too?:

  e862f1a atm: fix info leak in getsockopt(SO_ATMPVC)
  3c0c5cf atm: fix info leak via getsockname()
  e15ca9a Bluetooth: HCI - Fix info leak in getsockopt(HCI_FILTER)
  3f68ba0 Bluetooth: HCI - Fix info leak via getsockname()
  9ad2de4 Bluetooth: RFCOMM - Fix info leak in getsockopt(BT_SECURITY)
  f9432c5 Bluetooth: RFCOMM - Fix info leak in ioctl(RFCOMMGETDEVLIST)
  9344a97 Bluetooth: RFCOMM - Fix info leak via getsockname()
  792039c Bluetooth: L2CAP - Fix info leak via getsockname()
  04d4fbc l2tp: fix info leak via getsockname()
  3592aae llc: fix info leak via getsockname()
  7b07f8e dccp: fix info leak via getsockopt(DCCP_SOCKOPT_CCID_TX_INFO)
  2d8a041 ipvs: fix info leak in getsockopt(IP_VS_SO_GET_TIMEOUT)
  43da5f2 net: fix info leak in compat dev_ifconf()

Those were not CCed to stable but David wanted to queue them anyway. See

  http://marc.info/?l=linux-kernel&m=134509201708293&w=2


Thanks,
Mathias
