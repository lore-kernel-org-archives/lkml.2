Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab2FMUfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 16:35:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53940 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab2FMUfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 16:35:53 -0400
Date: Wed, 13 Jun 2012 13:35:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Minerds <puzzleduck@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] USB: serial: Changes to conform with checkpatch.sh
 script.
Message-ID: <20120613203547.GA4742@kroah.com>
References: <1338214920-32708-1-git-send-email-puzzleduck@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338214920-32708-1-git-send-email-puzzleduck@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 12:21:54AM +1000, Ben Minerds wrote:
> Updated patch series to remove various warnigs and errors when checkpatch script is run against drivers/usb/serial/keyspan.c.
> Previous version was created from Linuses tree, fixed to use linux-next tree.


Please line-wrap your emails.

And for that matter, your subject: lines shouldn't be longer than 72
columns as well.  Please try something better like:
	USB: serial: Keyspan: did something

And put the full description in the body of the changelog commit.

Care to fix these 6 patches up and resend them?  As they are, I can't
accept them unless I edited them by hand, and I don't have the time to
do that right now :(

thanks,

greg k-h
