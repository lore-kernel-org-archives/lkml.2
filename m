Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab1AJAUV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 19:20:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51372
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818Ab1AJAUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 19:20:20 -0500
Date: Sun, 09 Jan 2011 16:20:52 -0800 (PST)
Message-Id: <20110109.162052.98884306.davem@davemloft.net>
To: rjw@sisk.pl
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] forcedeth: Do not use legacy PCI power management
From: David Miller <davem@davemloft.net>
In-Reply-To: <201101072212.05449.rjw@sisk.pl>
References: <201101070049.16833.rjw@sisk.pl>
	<201101072212.05449.rjw@sisk.pl>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Fri, 7 Jan 2011 22:12:05 +0100

> Subject: forcedeth: Do not use legacy PCI power management (v2)
> 
> The forcedeth driver uses the legacy PCI power management, so it has
> to do PCI-specific things in its ->suspend() and ->resume() callbacks
> and some of them are not done correctly.
> 
> Convert forcedeth to the new PCI power management framework and make
> it let the PCI subsystem take care of all the PCI-specific aspects of
> device handling during system power transitions.
> 
> Tested with nVidia Corporation MCP55 Ethernet (rev a2).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Applied, thanks.
