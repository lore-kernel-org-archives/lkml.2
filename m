Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab0D1UL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 16:11:28 -0400
Received: from mail.perches.com ([173.55.12.10]:1805 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591Ab0D1UL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 16:11:27 -0400
Subject: Re: [PATCH 09/13] drivers/staging/rtl8192su: Hoist assign from if
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
In-Reply-To: <20100428194100.GA3602@suse.de>
References: <cover.1269493047.git.joe@perches.com>
	 <c45ba099fc8f31f166c4067f2eff609c8eaf422f.1269493047.git.joe@perches.com>
	 <20100428182710.GD8509@kroah.com>
	 <1272481489.7831.24.camel@Joe-Laptop.home> <20100428191116.GA29828@suse.de>
	 <1272482446.9188.4.camel@Joe-Laptop.home>  <20100428194100.GA3602@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 13:11:25 -0700
Message-ID: <1272485485.1609.18.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-28 at 12:41 -0700, Greg KH wrote:
> > Define _trivial_ and define obvious.
> "I know it when I see it."

As do I.

It wasn't an autoscript only process.

I inspected all of those hoist patches before sending them
modified some and decided not to modify others.


