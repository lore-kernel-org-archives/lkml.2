Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085Ab0JHVTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 17:19:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41189
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933025Ab0JHVTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 17:19:52 -0400
Date: Fri, 08 Oct 2010 14:20:13 -0700 (PDT)
Message-Id: <20101008.142013.68132581.davem@davemloft.net>
To: dilinger@queued.net
Cc: grant.likely@secretlab.ca, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v3] sparc: convert various prom_* functions to use
 phandle
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101008141811.19074b7c@debxo>
References: <20101008141811.19074b7c@debxo>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andres Salomon <dilinger@queued.net>
Date: Fri, 8 Oct 2010 14:18:11 -0700

> 
> Rather than passing around ints everywhere, use the
> phandle type where appropriate for the various functions
> that talk to the PROM.
> 
> v3: revert v2 changes, and include linux/of.h in openprom.h
>     instead of linux/types.h.
> 
> Note: this has only been compile-tested for 64bit sparc.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Acked-by: David S. Miller <davem@davemloft.net>
