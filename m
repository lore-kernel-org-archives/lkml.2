Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893Ab2JDAnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 20:43:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34972 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964801Ab2JDAnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 20:43:40 -0400
Date: Wed, 03 Oct 2012 20:43:36 -0400 (EDT)
Message-Id: <20121003.204336.1981040659629176119.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: haicheng.li@linux.intel.com, netdev@vger.kernel.org, tshimizu818@gmail.com,
        linux-kernel@vger.kernel.org, haicheng.lee@gmail.com
Subject: Re: [PATCH 1/2] Fix build error caused by broken PCH_PTP module
 dependency.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1349300710.2763.8.camel@bwh-desktop.uk.solarflarecom.com>
References: <50654A62.5090003@linux.intel.com>
	<20121002.222238.1580734803370802133.davem@davemloft.net>
	<1349300710.2763.8.camel@bwh-desktop.uk.solarflarecom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Wed, 3 Oct 2012 22:45:10 +0100

> I thought of it as being a peripheral feature (which most Solarflare
> hardware doesn't implement) so it made sense for SFC_PTP to be optional
> like SFC_MTD and so on.  But I'm quite happy to use a select instead, if
> you want that to be the convention for all drivers implementing PHC.

I think that consistency might trump those conerns you mentioned, at
least in this case.
