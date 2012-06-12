Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2FLRhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:37:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39560 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab2FLRhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:37:08 -0400
Date: Tue, 12 Jun 2012 10:37:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Marcus Karlsson <mk@acc.umu.se>
Cc: thomas@m3y3r.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rts_pstor: fixed some coding style errors
Message-ID: <20120612173703.GA2499@kroah.com>
References: <1338496799-13437-1-git-send-email-mk@acc.umu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338496799-13437-1-git-send-email-mk@acc.umu.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 10:39:59PM +0200, Marcus Karlsson wrote:
> Fixed some code styling errors in the following files:
> 
> drivers/staging/rts_pstor/rtsx_scsi.c:
> * multiple statements on single line
> 
> drivers/staging/rts_pstor/trace.h:
> * trailing whitespace
> * non-enclosed macro
> 
> drivers/staging/rts_pstor/xd.c:
> * trailing whitespace

Please break this up into individual patches, each doing one thing.
Doing all of this in one large patch makes it much harder to review.

thanks,

greg k-h
