Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab0HPGRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 02:17:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49628
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468Ab0HPGRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 02:17:41 -0400
Date: Sun, 15 Aug 2010 23:17:58 -0700 (PDT)
Message-Id: <20100815.231758.241456849.davem@davemloft.net>
To: dilinger@queued.net
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sparc: make driver/of/pdt no longer sparc-specific
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100816002244.6ddf37e6@debxo>
References: <20100809013245.1cefb9bf@dev.queued.net>
	<20100808.223444.62324566.davem@davemloft.net>
	<20100816002244.6ddf37e6@debxo>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andres Salomon <dilinger@queued.net>
Date: Mon, 16 Aug 2010 00:22:44 -0400

> I'm tempted to break the phandle/device_node/property stuff out into a
> separate header (that gets exported), and include that from linux/of.h
> and asm/openprom.h.

We could put just phandle into linux/types.h
