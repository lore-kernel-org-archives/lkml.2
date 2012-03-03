Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab2CCMaH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 07:30:07 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55463 "EHLO
	jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab2CCMaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 07:30:05 -0500
Date: Sat, 3 Mar 2012 13:20:14 +0100
From: Martin Mares <mj@ucw.cz>
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        javier.martinez@collabora.co.uk, rodrigo.moya@collabora.co.uk,
        javier@collabora.co.uk, lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
Message-ID: <mj+md-20120303.121749.5041.albireo@ucw.cz>
References: <CABBYNZJ-xxQXAx+ecrkVLqmWFaUVqLcQLj0Jxa3McSLnkLJSJw@mail.gmail.com>
 <20120301.170848.432407217191581288.davem@davemloft.net>
 <CABBYNZLwHKd5srzYYzWNL-iaeuH1K31824pY_bjRSbSLkv0QtA@mail.gmail.com>
 <20120302.035509.1994457175982020283.davem@davemloft.net>
 <CABBYNZJWKGpkK2mSbGCQ2KkE+jC3ih-wR3JQZSMgj7AYhbxeuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABBYNZJWKGpkK2mSbGCQ2KkE+jC3ih-wR3JQZSMgj7AYhbxeuw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> Instead we should add many times that into dbus-daemon and do IP
> multicast, am I missing something?

I completely agree with Alan that if routing all messages through
DBUS daemon is a bottleneck, then something is seriously wrong with
the way the applications use the message bus.

Also, you mentioned the need of passing fd's between applications.
If I understand correctly, it is a rare case and if you handle such
messages in the same way as before, it won't hurt performance.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
Even nostalgia isn't what it used to be.
