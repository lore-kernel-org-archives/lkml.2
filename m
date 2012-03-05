Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab2CEOGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:06:07 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:40319 "EHLO
	jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab2CEOGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 09:06:00 -0500
Date: Mon, 5 Mar 2012 15:05:57 +0100
From: Martin Mares <mj@ucw.cz>
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, shemminger@vyatta.com,
        ying.xue@windriver.com, rodrigo.moya@collabora.co.uk,
        javier@collabora.co.uk, lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
Message-ID: <mj+md-20120305.140318.15543.albireo@ucw.cz>
References: <CABBYNZJ-xxQXAx+ecrkVLqmWFaUVqLcQLj0Jxa3McSLnkLJSJw@mail.gmail.com>
 <20120301.170848.432407217191581288.davem@davemloft.net>
 <CABBYNZLwHKd5srzYYzWNL-iaeuH1K31824pY_bjRSbSLkv0QtA@mail.gmail.com>
 <20120302.035509.1994457175982020283.davem@davemloft.net>
 <4F509274.9060302@collabora.co.uk>
 <1330694031.2469.15.camel@edumazet-laptop>
 <4F50F6AA.9050909@collabora.co.uk>
 <20120302170823.7117821b@pyramind.ukuu.org.uk>
 <CABBYNZKhoT-POaaSvHoNLXU+hkPCiY_eqjEqDgzCqq4RvEvNXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABBYNZKhoT-POaaSvHoNLXU+hkPCiY_eqjEqDgzCqq4RvEvNXg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Please check the link above and tell me if that different than the
> model you suggested using BPF, apparently we are talking about the
> very same solution but the implementation detail are getting in the
> way because a lot of code was added.

...

First of all, you should come up with some real data confirming that
the problem you are trying to solve really exist -- i.e., that in some
real (and sensible) setup, routing all messages through DBUS daemon
is a bottleneck.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
More memory available, but not for you!
