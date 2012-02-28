Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030217Ab2B1TSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:18:33 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:48385 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966004Ab2B1TSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:18:32 -0500
Date: Tue, 28 Feb 2012 14:13:34 -0500 (EST)
Message-Id: <20120228.141334.569125676685228205.davem@davemloft.net>
To: stigge@antcom.de
Cc: baruch@tkos.co.il, alexander.h.duyck@intel.com, ian.campbell@citrix.com,
        netdev@vger.kernel.org, eilong@broadcom.com, kevin.wells@nxp.com,
        w.sang@pengutronix.de, jeffrey.t.kirsher@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: LPC32xx: Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F4CD1D8.8030102@antcom.de>
References: <4F4CD1D8.8030102@antcom.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 28 Feb 2012 11:13:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Stigge <stigge@antcom.de>
Date: Tue, 28 Feb 2012 14:08:40 +0100

> For the case that it _isn't_ initialized already, is it the right thing
> to use a hard coded default MAC address to be replaced by the final one
> in userspace? (I found such examples in some current micrel/ and amd/
> drivers.)

You use a randomized ethernet address which can subsequently be fixed up
by userspace, and we have very specific interfaces to make this very
easy for you.  It even sets an attribute which userland can query to see
that the device has a randomized ethernet address rathern than a true
assigned permanent one.
