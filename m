Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2BAALM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 19:11:12 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53929 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2BAALL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 19:11:11 -0500
Date: Tue, 31 Jan 2012 19:08:30 -0500 (EST)
Message-Id: <20120131.190830.1189531706541596294.davem@davemloft.net>
To: steweg@ynet.sk
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v7, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGsizzLTHw5Ja3kT-zEN8uK5GrzpmN1bxOhA0OscGL5R6tH3WA@mail.gmail.com>
References: <4168018.821328016111235.JavaMail.root@5-MeO-DMT.ynet.sk>
	<20120131.115005.1292336126288944173.davem@davemloft.net>
	<CAGsizzLTHw5Ja3kT-zEN8uK5GrzpmN1bxOhA0OscGL5R6tH3WA@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 31 Jan 2012 16:08:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ¦tefan Gula <steweg@ynet.sk>
Date: Wed, 1 Feb 2012 00:32:04 +0100

> About the new API. Openvswitch is using it's own GRE code, with it's
> own API. So if the finally NVGRE or VXLAN will be added to
> openvswitch,it doesn't breaks anything to leave also my API as is.

You don't understand.

If your code is superfluous in the end, we shouldn't add it in
the first place.

But if I do relent and let your code in now, we have to live
with it, and it's associated maintainence costs, FOREVER.

That's why I'm forcing this to be implemented properly from the start,
so we don't end up with two pieces of code that provide essentially
the same functionality.
