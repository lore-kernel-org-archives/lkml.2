Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab0ECJBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 05:01:37 -0400
Received: from smtp141.iad.emailsrvr.com ([207.97.245.141]:40698 "EHLO
	smtp141.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0ECJBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 05:01:35 -0400
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 May 2010 05:01:35 EDT
Message-ID: <4BDE8DCB.4000404@aljex.com>
Date: Mon, 03 May 2010 04:48:11 -0400
From: "Brian K. White" <brian@aljex.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: orenl@cs.columbia.edu, linux-s390@vger.kernel.org,
       linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       x86@kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, sukadev@linux.vnet.ibm.com, xemul@openvz.org
Subject: Re: [PATCH v21 001/100] eclone (1/11): Factor out code to allocate
 pidmap page
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>	<1272723382-19470-2-git-send-email-orenl@cs.columbia.edu> <20100501.151022.190375136.davem@davemloft.net>
In-Reply-To: <20100501.151022.190375136.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> NO WAY, there is no way in the world you should post 100 patches
> at a time to any mailing list, especially those at vger.kernel.org
> that have thousands upon thousands of subscribers.
> 
> Post only small, well contained, sets of patches at a time.  At most
> 10 or so in one go.
> 
> Do you realize how much mail traffic you generate by posting so many
> patches at one time, and how unlikely it is for anyone to actually
> sift through and review your patches after you've spammed them by
> posting so many at one time?
> 
> A second infraction and I will have no choice but to block you at the
> SMTP level at vger.kernel.org so please do not do it again.

Some people, you give them gold and they just complain it's heavy.

-- 
bkw
