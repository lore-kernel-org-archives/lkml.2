Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2KFIRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:17:42 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45920 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753866Ab2KFIRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:17:40 -0500
X-Sasl-enc: RRTpn3Jxn5OV24bEMYpoB8D0N1jqhGjZopCagm1vrtWi 1352189859
Date: Tue, 6 Nov 2012 09:17:49 +0100
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shubhrajyoti D <shubhrajyoti@ti.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the tty tree with the arm tree
Message-ID: <20121106081749.GB24564@kroah.com>
References: <20121106145332.5fd40abf0d74f8239156f75e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106145332.5fd40abf0d74f8239156f75e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 02:53:32PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> drivers/tty/serial/omap-serial.c between commit d864c03bfce2 ("SERIAL:
> omap: remove setting of EFR SCD bit") from the arm tree and commit
> 7ba897d77ce2 ("serial: omap: Remove the default setting of special
> character") from the tty tree.
> 
> I fixed it up (using the version from the arm tree) and can carry the fix
> as necessary (no action is required).

That sounds fine, thanks.

greg k-h
