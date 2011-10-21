Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab1JUGxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 02:53:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39063 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab1JUGxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 02:53:03 -0400
Message-ID: <1319179973.2854.62.camel@edumazet-laptop>
Subject: Re: [PATCH] dev: use name hash for dev_seq_ops
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mihai Maruseac <mihai.maruseac@gmail.com>
Cc: davem@davemloft.net, shemminger@vyatta.com, mirq-linux@rere.qmqm.pl,
        therbert@google.com, jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dbaluta@ixiacom.com,
        Mihai Maruseac <mmaruseac@ixiacom.com>
Date: Fri, 21 Oct 2011 08:52:53 +0200
In-Reply-To: <1319179510-10715-1-git-send-email-mmaruseac@ixiacom.com>
References: <1319097717-14910-1-git-send-email-mmaruseac@ixiacom.com>
	 <1319179510-10715-1-git-send-email-mmaruseac@ixiacom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 21 octobre 2011 à 09:45 +0300, Mihai Maruseac a écrit :
> Instead of using the dev->next chain and trying to resync at each call to
> dev_seq_start, use the name hash, keeping the bucket and the offset in
> seq->private field.
> 
...
> Signed-off-by: Mihai Maruseac <mmaruseac@ixiacom.com>

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Thanks


