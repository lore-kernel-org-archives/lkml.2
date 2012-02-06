Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2BFWtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:49:50 -0500
Received: from c60.cesmail.net ([216.154.195.49]:47382 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab2BFWtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:49:47 -0500
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Feb 2012 17:49:47 EST
Date: Mon, 6 Feb 2012 17:40:02 -0500
From: Pavel Roskin <proski@gnu.org>
To: David Gibson <hermes@gibson.dropbear.id.au>
Cc: Linus Torvalds <torvalds@osdl.org>, orinoco-users@lists.sourceforge.net,
        orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Orinoco-users] orinoco: Remove old mailing lists from
 MAINTAINERS
Message-ID: <20120206174002.31e13f75@mj>
In-Reply-To: <20120206030724.GC18754@truffala.fritz.box>
References: <20120206030724.GC18754@truffala.fritz.box>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Feb 2012 14:07:24 +1100
David Gibson <hermes@gibson.dropbear.id.au> wrote:

> The two orinoco mailing lists on sourceforge were set up many years
> ago and are now more or less moribund.  I'd like to shut them down, so
> I don't have to keep filtering the spam from them (which is most of
> what comes through now).  In preparation, this patch removes the
> reference to them from the MAINTAINERS file.  Any remaining discussion
> of this approaching obsolete driver can go to the linux-wireless list.
> 
> Please apply.
> 
> Signed-off-by: David Gibson <hermes@gibson.dropbear.id.au>

Acked-by: Pavel Roskin <proski@gnu.org>

> Index: working-2.6/MAINTAINERS
> ===================================================================
> --- working-2.6.orig/MAINTAINERS	2012-02-06 12:24:27.933527295
> +1100 +++ working-2.6/MAINTAINERS	2012-02-06
> 12:24:38.273578556 +1100 @@ -4906,8 +4906,6 @@ F:	fs/ocfs2/
>  
>  ORINOCO DRIVER
>  L:	linux-wireless@vger.kernel.org
> -L:	orinoco-users@lists.sourceforge.net
> -L:	orinoco-devel@lists.sourceforge.net
>  W:	http://linuxwireless.org/en/users/Drivers/orinoco
>  W:	http://www.nongnu.org/orinoco/
>  S:	Orphan

-- 
Regards,
Pavel Roskin
