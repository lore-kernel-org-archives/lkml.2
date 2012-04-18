Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab2DRX5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 19:57:19 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:32845 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab2DRX5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:57:18 -0400
Date: Wed, 18 Apr 2012 16:57:14 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "W. Trevor King" <wking@drexel.edu>
Cc: devel@linuxdriverproject.org,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        open list <linux-kernel@vger.kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: Re: [PATCH] staging: comedi: ni_tio_internal.h: checkpatch.pl
 cleanups
Message-ID: <20120418235714.GC5163@kroah.com>
References: <122f461c6a9b638022d67567811f4501b2a466b0.1334671099.git.wking@drexel.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <122f461c6a9b638022d67567811f4501b2a466b0.1334671099.git.wking@drexel.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 09:59:35AM -0400, W. Trevor King wrote:
> * Line wrapping to stay under 80 characters.
> * No braces for single statement blocks.

Please break this into 2 different patches.

Only do one thing per patch, that's the correct thing to do.

greg k-h
