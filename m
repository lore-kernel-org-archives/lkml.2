Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab2FMBCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 21:02:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53815 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2FMBCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 21:02:13 -0400
Date: Tue, 12 Jun 2012 18:02:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, oneukum@suse.de, linux-usb@vger.kernel.org
Subject: Re: [PATCH 02/13] code cleanup
Message-ID: <20120613010209.GB6765@kroah.com>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
 <1339057243-10029-3-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339057243-10029-3-git-send-email-stefani@seibold.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 10:20:32AM +0200, stefani@seibold.net wrote:
> From: Stefani Seibold <stefani@seibold.net>
> 
> - consistent nameing
> - more compact style
> - remove unneeded code
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  drivers/usb/usb-skeleton.c |  119 +++++++++++++++++---------------------------
>  1 files changed, 46 insertions(+), 73 deletions(-)

Your subject: needs to be fixed for all of these, as it does not
describe what part of the kernel is being modified.

A better example would be to use a prefix of:
	Subject: [PATCH XX/13] USB: skeleton: 
for all of these patches, so the shortlog entry is correct.

Care to redo this series, based on the feedback you've gotten, and
resend?

thanks,

greg k-h
