Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab1AXXBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:01:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42221
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399Ab1AXXBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:01:06 -0500
Date: Mon, 24 Jan 2011 15:01:40 -0800 (PST)
Message-Id: <20110124.150140.39171549.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: tglx@linutronix.de, netdev@vger.kernel.org,
        linux-net-drivers@solarflare.com, therbert@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next-2.6 2/5] lib: cpu_rmap: CPU affinity
 reverse-mapping
From: David Miller <davem@davemloft.net>
In-Reply-To: <1295471005.11126.86.camel@bwh-desktop>
References: <1295470787.11126.82.camel@bwh-desktop>
	<1295471005.11126.86.camel@bwh-desktop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Wed, 19 Jan 2011 21:03:25 +0000

> When initiating I/O on a multiqueue and multi-IRQ device, we may want
> to select a queue for which the response will be handled on the same
> or a nearby CPU.  This requires a reverse-map of IRQ affinity.  Add
> library functions to support a generic reverse-mapping from CPUs to
> objects with affinity and the specific case where the objects are
> IRQs.
> 
> Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>

Applied.
