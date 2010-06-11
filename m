Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab0FKUux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:50:53 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:8955 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab0FKUuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:50:51 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAM4+EkyrRN+K/2dsb2JhbACefHGlG5lshRgEg0w
X-IronPort-AV: E=Sophos;i="4.53,404,1272844800"; 
   d="scan'208";a="334289300"
Date: Fri, 11 Jun 2010 13:50:51 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: David Miller <davem@davemloft.net>
Cc: to@dvomlehn-lnx2.corp.sa.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4][RFC] Introduction to sk_buff state checking
Message-ID: <20100611205051.GA30404@dvomlehn-lnx2.corp.sa.net>
References: <20100611203350.GA28383@dvomlehn-lnx2.corp.sa.net> <20100611.133811.52184181.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100611.133811.52184181.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 01:38:11PM -0700, David Miller wrote:
> 
> This is the second time you've submitted this patch set,

There are changes, based on the feedback I got.

> it is also the second time that:
> 
> 1) Your email client has emitted these strange
>    "linux-kernel@vger.kernel.org"@cisco.com
>    addresses.
> 
>    I saw that you were specifically notified about this
>    problem during the previous submission.
> 
>    What did you do to try and correct it?
> 
> 2) You are not CC:'ing the networking developer mailing
>    list "netdev@vger.kernel.org"  Many networking developers
>    do not read linux-kernel, so by not CC:'ing that list
>    you are not reaching the folks most capable of reviewing
>    your patches.

All true, and I apologize. I know there's enough traffic on kernel mailing
lists as it is.

> Please fix this up.

Working on it now.

-- 
David VL
