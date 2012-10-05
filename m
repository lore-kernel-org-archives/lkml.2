Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab2JEHgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 03:36:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60445 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752300Ab2JEHgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 03:36:36 -0400
Message-ID: <1349422595.2008.55.camel@joe-AO722>
Subject: Re: [PATCH 19/20] drivers/net/ethernet/marvell/skge.c: fix error
 return code
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: David Miller <davem@davemloft.net>, peter.senna@gmail.com,
        shemminger@vyatta.com, mlindner@marvell.com,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 05 Oct 2012 00:36:35 -0700
In-Reply-To: <alpine.DEB.2.02.1210050712590.1958@localhost6.localdomain6>
References: <CA+MoWDp=_F9opJbVkv9sDsmoykm7MTUZwRVumKCB0ZqDwD6NoQ@mail.gmail.com>
	 <20121004.142335.1467206545795435493.davem@davemloft.net>
	 <CA+MoWDqBF5bdQYBaUmpB99Q=YcHYcUxi8Ffo3x4s0B+pmomb+Q@mail.gmail.com>
	 <20121004.145419.1859367129463136197.davem@davemloft.net>
	 <1349395795.2008.26.camel@joe-AO722>
	 <alpine.DEB.2.02.1210050712590.1958@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 07:22 +0200, Julia Lawall wrote:
> A tool was used to find a potential problem, and then Peter
> studied the code to see what fix was appropriate.

Hi Julia.

Was it true that a static analysis tool found the original
potential issue?  If so, what tool was it?

But wasn't the scripted fix applied to the rest of the tree
robotically?


