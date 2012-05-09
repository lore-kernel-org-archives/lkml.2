Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab2EIVoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 17:44:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48864 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab2EIVon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 17:44:43 -0400
Date: Wed, 9 May 2012 14:44:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Minerds <puzzleduck@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USB: serial: Whitespace and formatting to conform
 with checkpatch.sh script
Message-ID: <20120509214439.GA19041@kroah.com>
References: <1336569110-12835-1-git-send-email-puzzleduck@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336569110-12835-1-git-send-email-puzzleduck@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 11:11:50PM +1000, Ben Minerds wrote:
> Removed 19 errors and 53 warnings (space before tabs, spaces required
> around '?' ':' '=', space prohibited '(', trailing whitespace, not a
> function, and parentheses are not required).

That's nice, but please don't do this all in one patch.  Please do one
thing per patch (i.e. get rid of one type of warning or error per patch)

That way we can review it easier, and it can be applied easier.  As it
is, this patch doesn't apply to my usb-next branch due to other patches
in there already for this file that conflict with it.

Care to redo it and break it up and resend it?

thanks,

greg k-h
