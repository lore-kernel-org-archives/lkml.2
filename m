Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab1EBJrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 05:47:09 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:34043 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330Ab1EBJrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 05:47:06 -0400
Date: Mon, 2 May 2011 11:46:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ben Dooks <ben-i2c@fluff.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, eric.y.miao@gmail.com,
        ben-linux@fluff.org, linux-i2c@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: Re: [PATCH 1/3] i2c: append hardware lock with bus lock
Message-ID: <20110502114616.7813da79@endymion.delvare>
In-Reply-To: <20110502092734.GV15795@trinity.fluff.org>
References: <1304003746-12127-1-git-send-email-haojian.zhuang@gmail.com>
	<20110502092734.GV15795@trinity.fluff.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 May 2011 10:27:34 +0100, Ben Dooks wrote:
> On Thu, Apr 28, 2011 at 11:15:44PM +0800, Haojian Zhuang wrote:
> > Both AP and CP are contained in Marvell PXA910 silicon. These two ARM
> > cores are sharing one pair of I2C pins.
> > 
> > In order to keep I2C transaction operated with atomic, hardware lock
> > (RIPC) is required. Because of this, bus lock in AP side can't afford
> > this requirement. Now hardware lock is appended.
> > 
> > Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
> > Cc: Ben Dooks <ben-linux@fluff.org>
> > Cc: Jean Delvare <khali@linux-fr.org>
> 
> Right, this looks like a reasonable explanation of what is going on here
> and if Jean is happy with the core changes I'll look at where the driver
> change can go.

Yes I am!

Let me know if you want me to take the core change in my tree or if you
prefer to have it in yours to avoid a dependency.

-- 
Jean Delvare
