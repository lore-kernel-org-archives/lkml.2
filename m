Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1LISrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:47:37 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:44422 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab1LISrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:47:35 -0500
Date: Fri, 09 Dec 2011 13:45:14 -0500 (EST)
Message-Id: <20111209.134514.2071890208094978847.davem@davemloft.net>
To: lersek@redhat.com
Cc: ian.campbell@citrix.com, konrad.wilk@oracle.com, jeremy@goop.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 REPOST] xen-netfront: delay gARP until backend
 switches to Connected
From: David Miller <davem@davemloft.net>
In-Reply-To: <1323430738-3798-1-git-send-email-lersek@redhat.com>
References: <1323430738-3798-1-git-send-email-lersek@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 09 Dec 2011 10:45:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laszlo Ersek <lersek@redhat.com>
Date: Fri,  9 Dec 2011 12:38:58 +0100

> These two together provide complete ordering. Sub-condition (1) is
> satisfied by pvops commit 43223efd9bfd.

I don't see this commit in Linus's tree, so I doubt it's valid for
me to apply this as a bug fix to my 'net' tree since the precondition
pvops commit isn't upstream as far as I can tell.

Where did you intend me to apply this patch, and how did you expect
the dependent commit to make it's way into the tree so that this
fix is complete?

BTW, you should always explicitly specificy the answers to all the
questions in the previous paragraph, otherwise (like right now) we
go back and forth wasting time establishing these facts.

The way to say which tree the patch is intended for is to specify
it in the Subject like, f.e. "[PATCH net-next v3 REPOST] ..."

