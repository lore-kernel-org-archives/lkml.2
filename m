Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2JEICh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:02:37 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23975 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2JEICc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:02:32 -0400
Date: Fri, 5 Oct 2012 11:02:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, David Miller <davem@davemloft.net>,
        peter.senna@gmail.com, shemminger@vyatta.com, mlindner@marvell.com,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/20] drivers/net/ethernet/marvell/skge.c: fix error
 return code
Message-ID: <20121005080203.GX4587@mwanda>
References: <CA+MoWDp=_F9opJbVkv9sDsmoykm7MTUZwRVumKCB0ZqDwD6NoQ@mail.gmail.com>
 <20121004.142335.1467206545795435493.davem@davemloft.net>
 <CA+MoWDqBF5bdQYBaUmpB99Q=YcHYcUxi8Ffo3x4s0B+pmomb+Q@mail.gmail.com>
 <20121004.145419.1859367129463136197.davem@davemloft.net>
 <1349395795.2008.26.camel@joe-AO722>
 <alpine.DEB.2.02.1210050712590.1958@localhost6.localdomain6>
 <1349422595.2008.55.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349422595.2008.55.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 12:36:35AM -0700, Joe Perches wrote:
> On Fri, 2012-10-05 at 07:22 +0200, Julia Lawall wrote:
> > A tool was used to find a potential problem, and then Peter
> > studied the code to see what fix was appropriate.
> 
> Hi Julia.
> 
> Was it true that a static analysis tool found the original
> potential issue?  If so, what tool was it?
> 
> But wasn't the scripted fix applied to the rest of the tree
> robotically?

It was coccinelle.  It just prints a warning.  You have to go in
manually, review the code and pick the correct error code.

regards,
dan carpenter

