Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab2CSVAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 17:00:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34421 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751821Ab2CSVAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 17:00:05 -0400
Message-ID: <1332190804.6525.12.camel@joe2Laptop>
Subject: Re: [PATCH net-next] net: ipv4: Standardize prefixes for message
 logging
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 19 Mar 2012 14:00:04 -0700
In-Reply-To: <1331598952.13200.43.camel@joe2Laptop>
References: <1331526971.13200.9.camel@joe2Laptop>
	 <20120311.234846.455580505379366792.davem@davemloft.net>
	 <1331571812.13200.23.camel@joe2Laptop>
	 <20120312.170558.584205292599435892.davem@davemloft.net>
	 <1331598952.13200.43.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 17:35 -0700, Joe Perches wrote:
> On Mon, 2012-03-12 at 17:05 -0700, David Miller wrote:
> > From: Joe Perches <joe@perches.com>
> > Date: Mon, 12 Mar 2012 10:03:32 -0700
> > > Add #define pr_fmt(fmt) as appropriate.
> > > Add "IPv4: ", "TCP: ", and "IPsec: " to appropriate files.
> > > Standardize on "UDPLite: " for appropriate uses.
> > > Some prefixes were previously "UDPLITE: " and "UDP-Lite: ".
> []
> > Looks good, and applied,
> OK.  I'll submit a similar change for net/ipv6 in awhile.

Would you still take a similar IPv6: prefix
change for net-next or should I wait until
the next release cycle?

