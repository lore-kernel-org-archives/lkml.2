Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab1GJS0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 14:26:55 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:36630 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756219Ab1GJS0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:26:52 -0400
X-Sasl-enc: L+HRWNVE9i4S1eFDhoo50+42zkkcoJLPPXJKA6LzGwDH 1310322410
Date: Sun, 10 Jul 2011 11:26:34 -0700
From: Greg KH <greg@kroah.com>
To: markpearson_de@yahoo.de
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: Fixing style issues
Message-ID: <20110710182634.GA19612@kroah.com>
References: <1310321566-29266-1-git-send-email-markpearson_de@yahoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310321566-29266-1-git-send-email-markpearson_de@yahoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 08:12:46PM +0200, markpearson_de@yahoo.de wrote:
> From: Mark Pearson <markpearson_de@yahoo.de>
> 
> comedi_fops.c : Warning that externs should be avoided in .c files.
>                 A forward function decleration was declared extern
>                 although it was only used internally. Changed
>                 decleration to static.
> comedi.h      : Fixed warning that storage class should be a the
>                 begining of declerations.
> 
> Lindent ran on both files.
> 
> Ignore previous patch - forgot to add signed off by.

Care to break this up into a set of "only do one thing per patch"
series?  That way it's reviewable.

Also, running Lindent is usually a very bad idea on files that have been
around for a while now.  It causes a lot of unneeded churn, please just
make the minor changes needed to be checkpatch.pl clean by hand.

thanks,

greg k-h
