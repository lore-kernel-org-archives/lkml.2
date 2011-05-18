Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1ERU1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:27:18 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:45496 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752532Ab1ERU1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:27:11 -0400
Date: Wed, 18 May 2011 22:27:10 +0200
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: David Miller <davem@davemloft.net>
Cc: tsunanet@gmail.com, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: Expose the initial RTO via a new sysctl.
Message-ID: <20110518202710.GD4175@nuttenaction>
References: <BANLkTik-6wh8=jb6oMEpJvYC8+KTGGsMsw@mail.gmail.com>
 <20110518.155200.801089483916944725.davem@davemloft.net>
 <20110518202025.GC4175@nuttenaction>
 <20110518.162306.441229167098643303.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518.162306.441229167098643303.davem@davemloft.net>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller | 2011-05-18 16:23:06 [-0400]:

>Then this gets back to the fact that this is a network
>attribute and thus more suitable as a route metric not
>a global system-wide sysctl.

Yes, in an Email response to Eric I mentioned this already. The initial RTO is
a perfect candidate for route metric. I waiting for a patch to test it! ;-)

Hagen
