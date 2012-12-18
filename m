Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab2LRKYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 05:24:08 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:31419 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab2LRKYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 05:24:06 -0500
Date: Tue, 18 Dec 2012 11:23:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Laurent Navet <laurent.navet@gmail.com>, ben-linux@fluff.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver i2c-nforce2: fix pointer CodingStyle issues
Message-ID: <20121218112355.69369ee1@endymion.delvare>
In-Reply-To: <20121218100906.GB2612@pengutronix.de>
References: <1355778259-8445-1-git-send-email-laurent.navet@gmail.com>
	<20121218105223.0184d4a3@endymion.delvare>
	<CAH7P7Nhz2FpBct4afvAXU2Zgi-yA4TkJj7CtYMaW7pXr6weZig@mail.gmail.com>
	<20121218100906.GB2612@pengutronix.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2012 11:09:06 +0100, Wolfram Sang wrote:
> 
> > i have planned fixing these too, do you prefer one patch fixing all or
> > multiple patches (one per error/warning type )?
> 
> One patch, definately.

Yes please :)
> You can skip the 80 char thing.

For PCI device IDs, agreed.

> Are you also able to build-test the changes?

Most certainly yes, this driver has almost no dependencies. I will
build-test it anyway.


-- 
Jean Delvare
