Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966426Ab2ERSV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:21:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37485 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932790Ab2ERSV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:21:56 -0400
Date: Fri, 18 May 2012 11:21:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeffrin Jose <ahiliation@yahoo.co.in>
Cc: mdharm-usb@one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 452/452]USB :storage:fixed space at the start of a line
 issues.
Message-ID: <20120518182152.GB31313@kroah.com>
References: <1337364875-3494-1-git-send-email-ahiliation@yahoo.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337364875-3494-1-git-send-email-ahiliation@yahoo.co.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 11:44:35PM +0530, Jeffrin Jose wrote:
> Fixed space at the start of a line issues found
> by checkpatch.pl tool in drivers/usb/storage/usual-tables.c
> 
> Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>

Interesing use of spaces in the Subject line, not to mention where are
the 451 other patches that are supposed to be in this series?

Also, please use the scripts/get_maintainer.pl tool to figure out what
mailing list to send patches to (hint, you forgot a few...)

Care to try again?

thanks,

greg k-h
