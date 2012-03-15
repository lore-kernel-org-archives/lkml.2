Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762038Ab2COSzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:55:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48286 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2COSzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:55:18 -0400
Date: Thu, 15 Mar 2012 11:55:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Liz Clark <liz.clark@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: Wrong unicode value copied in con_set_unimap()
Message-ID: <20120315185514.GB11142@kroah.com>
References: <1331832809-4484-1-git-send-email-liz.clark@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331832809-4484-1-git-send-email-liz.clark@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 10:33:29AM -0700, Liz Clark wrote:
> Bugzilla 40012: PIO_UNIMAP bug: error updating Unicode-to-font map
> 
> The unicode font map for the virtual console is a 32x32x64 table which
> allocates rows dynamically as entries are added.  The unicode value
> increases sequentially and should count all entries even in empty
> rows.  The defect is when copying the unicode font map in con_set_unimap(),
> the unicode value is not incremented properly.  The wrong unicode value
> is entered in the new font map.
> 
> Signed-off-by: Liz Clark <liz.clark@hp.com>

Is this a new problem caused by recent changes in this area, or has it
always been there and needs to be backported to older kernels to solve
the problem there?

thanks,

greg k-h
