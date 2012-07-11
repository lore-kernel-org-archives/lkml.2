Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab2GKPIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:08:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48011 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab2GKPIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:08:39 -0400
Date: Wed, 11 Jul 2012 08:08:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Minerds <puzzleduck@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] USB: serial: Changes to conform with checkpatch.
Message-ID: <20120711150835.GA25117@kroah.com>
References: <1342015820-10229-1-git-send-email-puzzleduck@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342015820-10229-1-git-send-email-puzzleduck@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 12:10:14AM +1000, Ben Minerds wrote:
> Removed various checkpatch.sh warnings and errors. 
> Split patch by warning/error type.
> Corrected line wraps in emails.
> 
> Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
> ---
>  drivers/usb/serial/keyspan.c |  106 +++++++++++++++++++++---------------------
>  1 files changed, 53 insertions(+), 53 deletions(-)

I don't understand, is this 0/6 patch a "real" patch that should be
applied, or is it just a summary of the 1-6 patches all together?

Normally the 0/6 email is a text summary, and maybe the diffstat of the
whole patchset.  But not a patch itself with a signed-off-by line.

confused,

greg k-h
