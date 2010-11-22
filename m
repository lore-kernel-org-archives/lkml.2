Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab0KVQed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:34:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39752
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300Ab0KVQec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:34:32 -0500
Date: Mon, 22 Nov 2010 08:34:57 -0800 (PST)
Message-Id: <20101122.083457.189683493.davem@davemloft.net>
To: ddaney@caviumnetworks.com
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, cyril@ti.com,
        arnaud.patard@rtp-net.org, benh@kernel.crashing.org,
        w.sang@pengutronix.de
Subject: Re: [PATCH 0/2] phylib: Cleanup marvell.c and add 88E1149R support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1290203933-28251-1-git-send-email-ddaney@caviumnetworks.com>
References: <1290203933-28251-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney@caviumnetworks.com>
Date: Fri, 19 Nov 2010 13:58:51 -0800

> This is the second iteration of this patch.  I have split out the
> device tree support from the first version to a different patch set.
> The 88E1149R support is useful 'stand alone', so if it is acceptable,
> it can be merged first.
> 
> The first patch is a small cleanup suggested by Cyril Chemparathy, the
> second one adds basic 88E1149R support.

All applied to net-2.6, thanks.
