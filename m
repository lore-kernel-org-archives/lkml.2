Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab1KIVHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 16:07:40 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:38093 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab1KIVHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 16:07:39 -0500
Date: Wed, 09 Nov 2011 16:06:25 -0500 (EST)
Message-Id: <20111109.160625.886392843374581983.davem@davemloft.net>
To: prox@prolixium.com
Cc: dcbw@redhat.com, oliver@neukum.name, gregkh@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/usb: Misc. fixes for the LG-VL600 LTE USB modem
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111109185714.GA15884@prolixium.com>
References: <1320808200-28209-1-git-send-email-prox@prolixium.com>
	<1320861104.24903.4.camel@dcbw.foobar.com>
	<20111109185714.GA15884@prolixium.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 09 Nov 2011 13:06:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Kamichoff <prox@prolixium.com>
Date: Wed, 9 Nov 2011 13:57:14 -0500

> For (a), it's my understanding that __constant_htons() should be used
> only for initializers and htons() used in other cases, since it handles
> checking for constants.  I suppose you're right and this is a little
> gratuitous, but I wanted to keep things clean.
> 
> As far as (b), sorry!  That's an error on my part.  I must have been
> practicing another coding style at the time.  The braces certainly
> shouldn't be there, let me know if I should resubmit.

Please get rid of the gratuitous htons() etc. changes and keep this
patch purely to the bug fixes and resubmit.

Thank you.
