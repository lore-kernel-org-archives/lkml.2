Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1JUGzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 02:55:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab1JUGzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 02:55:52 -0400
Date: Fri, 21 Oct 2011 02:55:38 -0400 (EDT)
Message-Id: <20111021.025538.1690130663514126869.davem@redhat.com>
To: mihai.maruseac@gmail.com
Cc: shemminger@vyatta.com, eric.dumazet@gmail.com, mirq-linux@rere.qmqm.pl,
        therbert@google.com, jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dbaluta@ixiacom.com,
        mmaruseac@ixiacom.com
Subject: Re: [PATCH] dev: use name hash for dev_seq_ops
From: David Miller <davem@redhat.com>
In-Reply-To: <1319179510-10715-1-git-send-email-mmaruseac@ixiacom.com>
References: <1319097717-14910-1-git-send-email-mmaruseac@ixiacom.com>
	<1319179510-10715-1-git-send-email-mmaruseac@ixiacom.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mihai Maruseac <mihai.maruseac@gmail.com>
Date: Fri, 21 Oct 2011 09:45:10 +0300

> Instead of using the dev->next chain and trying to resync at each call to
> dev_seq_start, use the name hash, keeping the bucket and the offset in
> seq->private field.
> 
> Tests revealed the following results for ifconfig > /dev/null
 ...
> Signed-off-by: Mihai Maruseac <mmaruseac@ixiacom.com>

Applied.
