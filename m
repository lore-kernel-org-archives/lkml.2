Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1C1Bgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 21:36:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51287
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280Ab1C1Bgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 21:36:48 -0400
Date: Sun, 27 Mar 2011 18:36:10 -0700 (PDT)
Message-Id: <20110327.183610.15256387.davem@davemloft.net>
To: rjw@sisk.pl
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] Net / jme: Do not use legacy PCI power management
From: David Miller <davem@davemloft.net>
In-Reply-To: <201103261234.06274.rjw@sisk.pl>
References: <201103261234.06274.rjw@sisk.pl>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sat, 26 Mar 2011 12:34:06 +0100

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The jme driver uses the legacy PCI power management, so it has to do
> some PCI-specific things in its ->suspend() and ->resume() callbacks,
> which isn't necessary and should better be done by the PCI
> sybsystem-level power management code.  It also doesn't use device
> wakeup flags correctly.
> 
> Convert jme to the new PCI power management framework and make it
> let the PCI subsystem take care of all the PCI-specific aspects of
> device handling during system power transitions.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Applied, thanks a lot.
