Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab2AEDeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:34:14 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:55257 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525Ab2AEDeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:34:11 -0500
Date: Wed, 04 Jan 2012 22:30:52 -0500 (EST)
Message-Id: <20120104.223052.902437565229260010.davem@davemloft.net>
To: Larry.Finger@lwfinger.net
Cc: sfr@canb.auug.org.au, linville@tuxdriver.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the wireless-next tree with the
 net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F05151D.5070401@lwfinger.net>
References: <20120105140405.92816482d364abfcf3854d74@canb.auug.org.au>
	<4F05151D.5070401@lwfinger.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Jan 2012 19:30:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Wed, 04 Jan 2012 21:12:29 -0600

> Is there a good explanation why changes in wireless drivers are sent
> to net-next, and not wireless-testing? If that were stopped, this kind
> of conflict would be avoided.

It was a networking wide change and it's easiest if I just take it
in and deal with the merge issues.
