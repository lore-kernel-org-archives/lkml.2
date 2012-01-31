Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2AaS2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 13:28:54 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41766 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753505Ab2AaS2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 13:28:52 -0500
X-Sasl-enc: na8FvaGBSeRrad3vC0PHOhz+erkzQrlokx04FWqDnj2x 1328034531
Date: Tue, 31 Jan 2012 10:26:09 -0800
From: Greg KH <greg@kroah.com>
To: 20111025192636.f816c8860ee168a0a4756eda@canb.auug.org.au
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: Re: [PATCH] linux-next: et131x: Fixups due to merge issues from
 staging tree
Message-ID: <20120131182609.GA12819@kroah.com>
References: <20111025192636.f816c8860ee168a0a4756eda@canb.auug.org.au>
 <20111025121551.GA2108@marke.airties>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025121551.GA2108@marke.airties>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 01:15:52PM +0100, Mark Einon wrote:
> 
> Manually merged changes from commits afc4b13df143, bf3f1a6081aa and 5d6bcdfe38ce into et131x.c as identified in email below.
> 
> Also removed dependency on NETDEV_1000 in Kconfig, which no longer exists.
> 
> Greg: This patch should also be good for the staging tree.

I don't think this is needed anymore, right?

If so, please redo it against Linus's tree and send it to me.

thanks,

greg k-h
