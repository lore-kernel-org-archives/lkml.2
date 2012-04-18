Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2DRXaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 19:30:10 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:65283 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab2DRXaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:30:08 -0400
Date: Wed, 18 Apr 2012 16:30:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Andres Salomon <dilinger@queued.net>,
        Jordan Crouse <jordan@cosmicpenguin.net>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Valentin Rothberg <valentinrothberg@googlemail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: olpc_dcon.c: checkpatch.pl and style fixups
Message-ID: <20120418233004.GB9419@kroah.com>
References: <alpine.LNX.2.00.1204150049270.15578@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1204150049270.15578@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 12:53:04AM +0200, Jesper Juhl wrote:
> This patch removes the few checkpatch.pl issues that are currently
> reported for this file.
> 
> It makes these changes:
> 
> 1. Quoted strings that were broken over multiple lines are put on a
>    single line for easier grep'ability.

Woah, no, a patch should only do one single thing.

If you have to list what it does, you are not doing it correctly.

And, as this patch shows, people liked part of it, but not others, so
you had to redo it.  If you had split this up into individual patches, I
could have just accepted those and not the others.

So please, always break your patches up into the proper pieces.

greg k-h
