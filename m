Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab2DGMuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 08:50:40 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46900 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab2DGMuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 08:50:04 -0400
Date: Sat, 07 Apr 2012 08:46:57 -0400 (EDT)
Message-Id: <20120407.084657.1719148601003380853.davem@davemloft.net>
To: eldad@fogrefinery.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ipv6/exthdrs.c et al: Optional strict PadN option
 checking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1333795467-3643-1-git-send-email-eldad@fogrefinery.com>
References: <1333795467-3643-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 07 Apr 2012 05:46:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eldad Zack <eldad@fogrefinery.com>
Date: Sat,  7 Apr 2012 12:44:27 +0200

> Added strict checking of PadN, which can be used to increase header
> size and thus push the protocol header into the 2nd fragment.
> 
> PadN is used to align the options within the Hop-by-Hop or
> Destination Options header to 64-bit boundaries. The maximum valid
> size is thus 7 bytes.
> RFC 4942 recommends to actively check the "payload" itself and
> ensure that it contains only zeroes.
> 
> See also RFC 4942 section 2.1.9.5.
> 
> Signed-off-by: Eldad Zack <eldad@fogrefinery.com>

A sysctl _AND_ a kconfig option, give me a break, that's
pointless.

Either we want this or we don't.
