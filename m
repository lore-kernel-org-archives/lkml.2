Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1HWVms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 17:42:48 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:57809 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730Ab1HWVmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 17:42:43 -0400
X-Sasl-enc: EYa+K8ZE7ynVKqTmpQpZgdR71WThqY+ONad1S9CPwDlU 1314135762
Date: Tue, 23 Aug 2011 14:41:42 -0700
From: Greg KH <greg@kroah.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [RFC 1/2]drivers:staging:usbip:stub_dev.c change
 SPIN_LOCK_UNLOCKED to __SPIN_LOCK_UNLOCKED
Message-ID: <20110823214142.GE3679@kroah.com>
References: <1311960037-9581-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311960037-9581-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 10:20:36AM -0700, Justin P. Mattock wrote:
> From: "Justin P. Mattock" <justinmattock@gmail.com>
> 
> The patch below updates SPIN_LOCK_UNLOCKED to __SPIN_LOCK_UNLOCKED since it is 
> deprected according to my search results.
> Note: Keep in mind I am not sure if this is the correct change for this(still learning)
> even though it's commented out and such.(figured to give this a try and see).
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

As these were "RFC" I'm not going to apply them.

Care to test them out and see if they really work?

thanks,

greg k-h
