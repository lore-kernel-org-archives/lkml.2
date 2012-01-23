Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab2AWSqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:46:03 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:57313 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab2AWSqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:46:00 -0500
Date: Mon, 23 Jan 2012 13:44:54 -0500 (EST)
Message-Id: <20120123.134454.589237945281379533.davem@davemloft.net>
To: steweg@ynet.sk
Cc: kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v1, kernel version 3.2.1] Source mode for macvlan
 interaface
From: David Miller <davem@davemloft.net>
In-Reply-To: <22013455.801327321838477.JavaMail.root@5-MeO-DMT.ynet.sk>
References: <22013455.801327321838477.JavaMail.root@5-MeO-DMT.ynet.sk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 23 Jan 2012 10:44:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Gula <steweg@ynet.sk>
Date: Mon, 23 Jan 2012 13:30:38 +0100 (CET)

> New mode of macvlan interface called "source" allows one to specify, which  frames are allowed to be received by given macvlan interface. This logic is used only on received frames on underlaying interface. The ability to send frames from macvlan interface through underlaying interface is not modified. This feature allows one to simulate 802.1x mac based VLAN bahaviour by using proper netlink message to configure this behavior with utililty such as "ip link" from iproute2 suite.

Please properly format your commit messages, this is just one ugly 485
character long line.  Add newlines every 70 characters or so.
