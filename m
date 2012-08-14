Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2HNXXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:23:05 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:20728 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab2HNXXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:23:03 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 173.50.127.139
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19xvnIgcN/5NMF6RCAVWLWgEKMO+PHaH9M=
Date: Tue, 14 Aug 2012 19:22:56 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v2 1/2] ARM: kirkwood: DT board setup for Seagate
 FreeAgent Dockstar
Message-ID: <20120814232256.GX22226@titan.lakedaemon.net>
References: <20120814193613.GS22226@titan.lakedaemon.net>
 <1344977022-29037-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344977022-29037-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 10:43:41PM +0200, Sebastian Hesselbarth wrote:
> This add a DT compatible board specific setup for the Seagate
> FreeAgent Dockstar.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> 
> v2: rebased on git://git.infradead.org/users/jcooper/linux.git fixes-for-v3.6

patches [1/2] and [2/2] of this series applied to:

  git://git.infradead.org/users/jcooper/linux.git boards-for-v3.7

patch [2/2] depends upon:

  bda63c1 ARM: Kirkwood: fix Makefile.boot

which should be in an upcoming v3.6-rc

thx,

Jason.
