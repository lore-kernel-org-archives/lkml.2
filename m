Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab1JQWdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:33:21 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:60661 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879Ab1JQWdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:33:20 -0400
X-Sasl-enc: EPvlsknu/pfG1FKK81iVbvhZa2sGZ0xK2aGIUSpOz0iZ 1318890799
Date: Mon, 17 Oct 2011 15:29:12 -0700
From: Greg KH <greg@kroah.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] staging: et131x: Put all .c files into one big file
Message-ID: <20111017222912.GA20885@kroah.com>
References: <1318455402-10596-1-git-send-email-mark.einon@gmail.com>
 <1318455402-10596-2-git-send-email-mark.einon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318455402-10596-2-git-send-email-mark.einon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 10:36:33PM +0100, Mark Einon wrote:
> Created one big .c file for the driver, moving the contents of all
> driver .c files into it.

This patch doesn't apply properly, so the rest of the series doesn't as
well.

Care to redo it against my staging-next branch so that I can properly
apply it?

Because of this, I'll drop this series, and the other one you sent me,
from my "to-apply" mailbox, feel free to resend them when you resync
back up.

thanks,

greg k-h
