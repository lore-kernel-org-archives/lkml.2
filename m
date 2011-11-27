Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab1K0JvZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 04:51:25 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42200 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241Ab1K0JvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 04:51:24 -0500
X-Sasl-enc: t57kVqQ46ajwyE2kF+EmBNJUcKCjom1Dd+tOv8Wfzxcd 1322387482
Date: Sat, 26 Nov 2011 17:55:59 -0800
From: Greg KH <greg@kroah.com>
To: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: devel@driverdev.osuosl.org, greg@suse.de, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] drivers/staging/vt6656/iwctl.c: Remove
 unnecessary function
Message-ID: <20111127015559.GB27297@kroah.com>
References: <1322161780-3731-1-git-send-email-marcos.mage@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322161780-3731-1-git-send-email-marcos.mage@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 07:09:40PM +0000, Marcos Paulo de Souza wrote:
> Removed the function iwctl_giwnwid, that was used once. Removed too a
> switch/case statement that was ambiguous.

You've sent a bunch of vt66* patches recently, could you handle all of
the review comments that I've made, and resend all of them, so I can
properly apply them, as I don't know which ones depend on which.

thanks,

greg k-h
