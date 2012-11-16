Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab2KPBVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 20:21:31 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47320 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab2KPBVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:21:30 -0500
Date: Thu, 15 Nov 2012 17:21:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Slaby <jslaby@suse.cz>, alan@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] TTY: memory leaks patchset
Message-ID: <20121116012127.GA12364@kroah.com>
References: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
 <20121115104254.3029bca9@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121115104254.3029bca9@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 10:42:54AM +0000, Alan Cox wrote:
> > This series should go upstream regardless "TTY: move tty buffers to
> > tty_port" if we decide to revert that commit due to the reported
> > warnings I cannot reproduce and neither catch the root cause.
> 
> They seem to be warnings only and very obscure cases. I'd favour that
> patch not being reverted simply because the only way we'll find a pattern
> is by a lot more reports - and it doesn't seem to be anything but an
> annoying log splat.

I agree, it should stay to help catch any further problems that haven't
been fixed up yet.

thanks,

greg k-h
