Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab1D1ELu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 00:11:50 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34579 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1D1ELs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 00:11:48 -0400
Date: Thu, 28 Apr 2011 01:12:03 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the bluetooth tree
Message-ID: <20110428041202.GB2214@joana>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110428114118.dd5a74e0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110428114118.dd5a74e0.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

* Stephen Rothwell <sfr@canb.auug.org.au> [2011-04-28 11:41:18 +1000]:

> Hi Gustavo,
> 
> After merging the bluetooth tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> net/bluetooth/cmtp/core.c: In function 'cmtp_add_connection':
> net/bluetooth/cmtp/core.c:349: error: 'struct l2cap_pinfo' has no member named 'omtu'
> net/bluetooth/cmtp/core.c:349: error: 'struct l2cap_pinfo' has no member named 'imtu'
> net/bluetooth/hidp/core.c: In function 'hidp_add_connection':
> net/bluetooth/hidp/core.c:982: error: 'struct l2cap_pinfo' has no member named 'omtu'
> net/bluetooth/hidp/core.c:982: error: 'struct l2cap_pinfo' has no member named 'imtu'
> net/bluetooth/hidp/core.c:983: error: 'struct l2cap_pinfo' has no member named 'omtu'
> net/bluetooth/hidp/core.c:983: error: 'struct l2cap_pinfo' has no member named 'imtu'
> 
> Caused by commit 6657e8f0cc05 ("Bluetooth: Move more channel info to
> struct l2cap_chan").

Thanks for spotting this, It's fixed now.

-- 
Gustavo F. Padovan
http://profusion.mobi
