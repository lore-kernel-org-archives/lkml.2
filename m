Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab1LUUjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:39:47 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:55067 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1LUUjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:39:44 -0500
Date: Wed, 21 Dec 2011 15:39:42 -0500 (EST)
Message-Id: <20111221.153942.1154751416833093680.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 RFC (repost) 10/16] sparc: switch to GENERIC_PCI_IOMAP
From: David Miller <davem@davemloft.net>
In-Reply-To: <8eae6aac2016df44117feea0497aa8f9e52271cc.1324484752.git.mst@redhat.com>
References: <cover.1324484752.git.mst@redhat.com>
	<8eae6aac2016df44117feea0497aa8f9e52271cc.1324484752.git.mst@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Dec 2011 12:39:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 21 Dec 2011 18:29:51 +0200

> sparc copied pci_iomap from generic code, probably to avoid
> pulling the rest of iomap.c in.  Since that's in
> a separate file now, we can reuse the common implementation.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: David S. Miller <davem@davemloft.net>

FWIW, I just tested this as well and it works fine.

BTW, must be a thinko that you're CC:'ing linux-alpha for this
patch :-)
