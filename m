Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab2KEFxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 00:53:46 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42914 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2KEFxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 00:53:45 -0500
Date: Mon, 05 Nov 2012 00:53:43 -0500 (EST)
Message-Id: <20121105.005343.973313737817968846.davem@davemloft.net>
To: cardoe@cardoe.com
Cc: kaber@trash.net, netdev@vger.kernel.org,
        systemd-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vlan: set sysfs device_type to 'vlan'
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAFWqQMSes5J1bjUA6NBiWKrjbdUKJkhz-mdNYhGLU-A8cksxZg@mail.gmail.com>
References: <1350885237-12998-1-git-send-email-cardoe@cardoe.com>
	<20121023.023647.2164665243829038911.davem@davemloft.net>
	<CAFWqQMSes5J1bjUA6NBiWKrjbdUKJkhz-mdNYhGLU-A8cksxZg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Goldstein <cardoe@cardoe.com>
Date: Sun, 4 Nov 2012 23:45:56 -0600

> As Ben Greear pointed out this would allow shell scripts and other
> scripting languages to better detect vlans. Kay pointed out that this
> would allow better uevent filters in the future as well. So there are
> some merits to this patch. If you'd prefer I can resubmit with a
> better commit message entailing the reasons behind it.

For the thousandth time:

All of those scripts and other users of this new facility will
need to have backup code to detect vlan devices when this
sysfs thing is not present.

They are already to determine this information already, and
they alreayd have to be ugly to handle EVERY EXISTING KERNEL
ON THE PLANET.

So the effective value is zero.
