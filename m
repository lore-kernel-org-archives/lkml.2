Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab2JHMjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 08:39:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19060 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab2JHMjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:39:16 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ZoxANpzFkQoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=4mhtMHHRE_oA:10 a=hQ7m24HvcpjOt7RSy4AA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349699954.6755.110.camel@gandalf.local.home>
Subject: Re: [STABLE][3.0][3.2][Add PATCH] phy/fixed: use an unique MDIO bus
 name
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: ben@decadent.org.uk, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, florian@openwrt.org,
        netdev@vger.kernel.org
Date: Mon, 08 Oct 2012 08:39:14 -0400
In-Reply-To: <20121007.145622.83624305358947187.davem@davemloft.net>
References: <1349441987.6755.45.camel@gandalf.local.home>
	 <1349624019.16173.113.camel@deadeye.wl.decadent.org.uk>
	 <20121007.145622.83624305358947187.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-07 at 14:56 -0400, David Miller wrote:

> But this change impacted a lot of MDIO drivers and there were
> regressions that needed to be fixed up the first time this stuff
> went in.

If it's that big of a deal then we can forget about this fix. I can get
around it if I tweak my config. Probably just skip the MDIO stuff.

-- Steve


