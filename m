Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab1CCWAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:00:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33549
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758925Ab1CCWAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:00:30 -0500
Date: Thu, 03 Mar 2011 14:01:06 -0800 (PST)
Message-Id: <20110303.140106.191399853.davem@davemloft.net>
To: chris.friesen@genband.com
Cc: dev@nico22.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Network link detection
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D700A5B.2000807@genband.com>
References: <20110303193006.GA29129@svh.nico22.de>
	<4D700A5B.2000807@genband.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Friesen <chris.friesen@genband.com>
Date: Thu, 03 Mar 2011 15:38:35 -0600

> You might look at whether you could write a kernel module to register
> for NETDEV_CHANGE notifications and pass that back to userspace.

This is the kind of responses you get when you ask networking specific
questions and don't CC: netdev :-/

There is this thing called netlink, you can listen for arbitrary
network state change events on a socket, and get the link state
notifications you are looking for.  It's in use by many real
applications like NetworkManager and co.
