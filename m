Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab2ITH0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:26:14 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:58296 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab2ITH0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:26:12 -0400
Date: Thu, 20 Sep 2012 09:26:08 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Brad Spengler <spender@grsecurity.net>
Subject: Re: [PATCH 4/6] xfrm_user: fix info leak in copy_to_user_tmpl()
Message-ID: <20120920072608.GB4221@secunet.com>
References: <1348090423-32665-1-git-send-email-minipli@googlemail.com>
 <1348090423-32665-5-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348090423-32665-5-git-send-email-minipli@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 20 Sep 2012 07:26:08.0462 (UTC) FILETIME=[33DEE6E0:01CD9701]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 11:33:41PM +0200, Mathias Krause wrote:
> The memory used for the template copy is a local stack variable. As
> struct xfrm_user_tmpl contains multiple holes added by the compiler for
> alignment, not initializing the memory will lead to leaking stack bytes
> to userland. Add an explicit memset(0) to avoid the info leak.
> 
> Initial version of the patch by Brad Spengler.
> 
> Cc: Brad Spengler <spender@grsecurity.net>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>

Patches 1-4:

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

