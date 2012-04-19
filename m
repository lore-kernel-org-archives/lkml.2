Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab2DSUHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:07:39 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34733 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932246Ab2DSUHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:07:37 -0400
X-Sasl-enc: YG7Y223ojkYzWSF9L+ZPIvrg4+BWziJFwoCyL3auW1X+ 1334866056
Date: Thu, 19 Apr 2012 13:07:35 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: Re: linux-next: manual merge of the tty tree with the tty.current
 tree
Message-ID: <20120419200735.GC10059@kroah.com>
References: <20120419145951.4e1652ae5b1b80686892495d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419145951.4e1652ae5b1b80686892495d@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 02:59:51PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> drivers/tty/serial/pch_uart.c between commit af6d17cdc8c8 ("pch_uart: Fix
> dma channel unallocated issue") from the tty.current tree and commit
> 44db113212d8 ("pch_uart: Delete unused structure member") from the tty
> tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Looks correct, thanks.

greg k-h
