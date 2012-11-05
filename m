Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2KEGom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 01:44:42 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43214 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2KEGok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 01:44:40 -0500
Date: Mon, 05 Nov 2012 01:44:37 -0500 (EST)
Message-Id: <20121105.014437.768714358664336963.davem@davemloft.net>
To: cardoe@cardoe.com
Cc: kaber@trash.net, netdev@vger.kernel.org,
        systemd-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vlan: set sysfs device_type to 'vlan'
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAFWqQMRa6sPxqAJswu-6f06KxhqLSsY2T-dE3p-tpo4VEpwfdA@mail.gmail.com>
References: <CAFWqQMSes5J1bjUA6NBiWKrjbdUKJkhz-mdNYhGLU-A8cksxZg@mail.gmail.com>
	<20121105.005343.973313737817968846.davem@davemloft.net>
	<CAFWqQMRa6sPxqAJswu-6f06KxhqLSsY2T-dE3p-tpo4VEpwfdA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Goldstein <cardoe@cardoe.com>
Date: Mon, 5 Nov 2012 00:19:19 -0600

> By this argument we shouldn't ever improve any API or add new syscalls
> since we'll have to have fallback code to handle the old interfaces
> when the new ones aren't available.

It makes sense to add new APIs when existing mechanisms are too
difficult _AND_ code doesn't already exist that works reasonable well
with existing facilities.
