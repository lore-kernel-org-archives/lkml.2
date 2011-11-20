Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1KTUcF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 15:32:05 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:59919 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab1KTUcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 15:32:01 -0500
Date: Sun, 20 Nov 2011 15:31:56 -0500 (EST)
Message-Id: <20111120.153156.1383147368726575639.davem@davemloft.net>
To: himeraster@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mtk.manpages@gmail.com, linux-man@vger.kernel.org
Subject: Re: [bug] af_unix: Reading from a stream socket may lock the
 concurrent poll() call
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAHjqzy7dhqi22yPJX=DP4x916hVXDY2WaDbdmnTEQ54n6qpMXw@mail.gmail.com>
References: <CAHjqzy7dhqi22yPJX=DP4x916hVXDY2WaDbdmnTEQ54n6qpMXw@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 20 Nov 2011 12:32:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Moiseytsev <himeraster@gmail.com>
Date: Mon, 21 Nov 2011 00:19:02 +0400

> Other info:
> $ uname -srmo
> Linux 2.6.32-5-amd64 x86_64 GNU/Linux

There have been numerous AF_UNIX bug fixes since that release, please try
to reproduce your problem with current kernels.

Thanks.
