Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761178Ab2BNVGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:06:22 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:40284 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab2BNVGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:06:19 -0500
Message-ID: <1329253575.2555.16.camel@edumazet-laptop>
Subject: Re: [PATCH net-next] epoll: add EPOLLEXCLUSIVE support
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Davide Libenzi <davidel@xmailserver.org>
Date: Tue, 14 Feb 2012 22:06:15 +0100
In-Reply-To: <1329252484-6309-1-git-send-email-hagen@jauu.net>
References: <1329252484-6309-1-git-send-email-hagen@jauu.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 14 février 2012 à 21:48 +0100, Hagen Paul Pfeifer a écrit :
> High performance server sometimes create one listening socket (e.g. port
> 80), create a epoll file descriptor and add the socket. Afterwards
> create SC_NPROCESSORS_ONLN threads and wait for events. This often
> result in a thundering herd problem because all CPUs are scheduled.
> 
> This patch add an additional flag to epoll_ctl(2) called EPOLLEXCLUSIVE.
> If a descriptor is added with this flag only one CPU is scheduled in.
> 
> Signed-off-by: Hagen Paul Pfeifer <hagen@jauu.net>
> Reported-by: Li Yu <raise.sail@gmail.com>
> Cc: Davide Libenzi <davidel@xmailserver.org>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> ---

Seems pretty good to me.

Do you have some performance numbers to share ?




