Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab1GGNoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:44:55 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:49606 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932110Ab1GGNod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:44:33 -0400
X-Sasl-enc: od9TsakiLtlitYkPyJ61FoRg3dUKeBODLA++5ZP69NwS 1310046272
Date: Thu, 7 Jul 2011 06:43:38 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>
Subject: Re: linux-next: manual merge of the staging tree with the net tree
Message-ID: <20110707134338.GD26939@kroah.com>
References: <20110707154418.2ef06852c79eb96adcbe8c4e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707154418.2ef06852c79eb96adcbe8c4e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 03:44:18PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/rtl8192e/r8192E.h between commit 219eb47e6f35
> ("net/staging: add needed interrupt.h and hardirq.h includes") from the
> net tree and commit 41134db17a7d ("Remove unneeded version.h includes
> from drivers/staging/rtl*/") from the staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Gotta love #include merge issues :(

thanks for doing this,

greg k-h
