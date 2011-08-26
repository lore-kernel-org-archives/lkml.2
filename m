Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab1HZEeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 00:34:17 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46140 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750771Ab1HZEeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 00:34:15 -0400
X-Sasl-enc: Jr/ANzJoiQPfXrpDba5epcrDuNToQ8WHxbASa7MAcpUf 1314333254
Date: Thu, 25 Aug 2011 21:33:57 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Pirko <jpirko@redhat.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: linux-next: manual merge of the staging tree with the net tree
Message-ID: <20110826043357.GA17686@kroah.com>
References: <20110826134705.0d5b6767777f0af2f8667731@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826134705.0d5b6767777f0af2f8667731@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 01:47:05PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/rtl8192e/r8192E_core.c between commit afc4b13df143 ("net:
> remove use of ndo_set_multicast_list in drivers") from the net tree and
> commit 09505184ec3d ("staging: rtl8192e: Remove files that are not used")
> from the staging tree.
> 
> The latter removed the file, so I did that.

Thanks, that should be the correct thing :)

greg k-h
