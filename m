Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab2BNVi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:38:27 -0500
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:49166 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932104Ab2BNViY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:38:24 -0500
Date: Tue, 14 Feb 2012 22:38:23 +0100
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [PATCH net-next] epoll: add EPOLLEXCLUSIVE support
Message-ID: <20120214213823.GB6097@nuttenaction>
References: <1329252484-6309-1-git-send-email-hagen@jauu.net>
 <1329253575.2555.16.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329253575.2555.16.camel@edumazet-laptop>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Dumazet | 2012-02-14 22:06:15 [+0100]:

>Seems pretty good to me.
>
>Do you have some performance numbers to share ?

No, but I did some tests with one of my network performance tools. I imagine
that I can *construct* test-cases and add some 'perf stat cs:u' statistics.
IMHO it is not fair to present some artificial tunned performance numbers.
There are use-cases where EPOLLEXCLUSIVE can be really helpfull, yes I think
that this flag SHOULD be a userspace default. ;-)

Hagen
