Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab1JQWMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:12:38 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:35097 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755883Ab1JQWMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:12:35 -0400
X-Sasl-enc: g92RasWtusQDlHw/VRmfF2AN7U9KUA7wR6+qurnI7X8L 1318889555
Date: Mon, 17 Oct 2011 15:10:24 -0700
From: Greg KH <greg@kroah.com>
To: Johannes Thumshirn <morbidrsa@googlemail.com>
Cc: gregkh@suse.de, abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: comedi: Added log subjects to printk()s in
 pcmmio
Message-ID: <20111017221024.GA26595@kroah.com>
References: <1316926152-7258-1-git-send-email-morbidrsa@googlemail.com>
 <1317378693-18474-1-git-send-email-morbidrsa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317378693-18474-1-git-send-email-morbidrsa@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 12:31:33PM +0200, Johannes Thumshirn wrote:
> Added log subject to printk()s in drivers/staging/comedi/drivers/pcmmio.c.
> When necessary append trailing '\n' and leading identifier to log message to
> unbreak the output.
> 
> Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>

This patch doesn't apply at all, what did you make it against?

Care to redo it against linux-next so that I can apply it?

thanks,

greg k-h
