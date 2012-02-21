Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab2BUIRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 03:17:08 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44491 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2BUIRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 03:17:07 -0500
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Feb 2012 03:17:07 EST
Message-ID: <1329811621.17703.5.camel@chamonix>
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
From: Rodrigo Moya <rodrigo.moya@collabora.co.uk>
To: Colin Walters <walters@verbum.org>
Cc: Javier Martinez Canillas <javier@collabora.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Alban Crequy <alban.crequy@collabora.co.uk>,
        Bart Cerneels <bart.cerneels@collabora.co.uk>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 21 Feb 2012 09:07:01 +0100
In-Reply-To: <1329765252.22425.3.camel@lenny>
References: <1329753455-1106-1-git-send-email-javier@collabora.co.uk>
	 <1329765252.22425.3.camel@lenny>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 14:13 -0500, Colin Walters wrote:
> On Mon, 2012-02-20 at 16:57 +0100, Javier Martinez Canillas wrote:
> > This patch-set add multicast support to Unix domain socket familiy for datagram
> > and seqpacket sockets. This work was made by Alban Crequy as a result of a
> > research we have been doing to improve the performance of the D-bus IPC system.
> 
> Do you have links to any modifications to userspace dbus to take
> advantage of this?

we have a work in progress at
http://cgit.collabora.com/git/user/rodrigo/dbus.git/ in the
unix-sockets-multicast branch

