Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997Ab2IERAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 13:00:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42690 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758941Ab2IERAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 13:00:22 -0400
Date: Wed, 05 Sep 2012 13:00:20 -0400 (EDT)
Message-Id: <20120905.130020.768517336834373231.davem@davemloft.net>
To: swhiteho@redhat.com
Cc: xi.wang@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] decnet: fix shutdown parameter checking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1346834276.2799.4.camel@menhir>
References: <1346059001.2703.7.camel@menhir>
	<20120831.155719.2228399422573401952.davem@davemloft.net>
	<1346834276.2799.4.camel@menhir>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 05 Sep 2012 09:37:56 +0100

> However, I'm not overly worried and we'll soon know if it will cause any
> problems or not,

You can be sure that if we get real bug reports due to this change, I will
revert it back to how it was before.
