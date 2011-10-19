Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab1JSUti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 16:49:38 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:44938 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248Ab1JSUth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 16:49:37 -0400
X-Sasl-enc: 79gTlyx2J2Ia+sJY+5E9ny6OB2FyXWrh9hHtyhS5cl9O 1319057376
Date: Wed, 19 Oct 2011 13:41:28 -0700
From: Greg KH <greg@kroah.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/26] staging: et131x: Put all .c files into one big file
Message-ID: <20111019204128.GA6152@kroah.com>
References: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
 <1318954079-16666-2-git-send-email-mark.einon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318954079-16666-2-git-send-email-mark.einon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 05:07:34PM +0100, Mark Einon wrote:
> Created one big .c file for the driver, moving the contents of all
> driver .c files into it.
> 
> Signed-off-by: Mark Einon <mark.einon@gmail.com>

Something is wrong here, when I try to apply this patch with git, I get
the following errors:

$ git am -s ../s2
Applying: staging: et131x: Put all .c files into one big file
error: removal patch leaves file contents
error: drivers/staging/et131x/et1310_eeprom.c: patch does not apply
error: removal patch leaves file contents
error: drivers/staging/et131x/et1310_mac.c: patch does not apply
error: removal patch leaves file contents
error: drivers/staging/et131x/et1310_phy.c: patch does not apply
error: removal patch leaves file contents
error: drivers/staging/et131x/et1310_pm.c: patch does not apply
error: removal patch leaves file contents
error: drivers/staging/et131x/et1310_rx.c: patch does not apply
error: removal patch leaves file contents
error: drivers/staging/et131x/et1310_tx.c: patch does not apply
/home/gregkh/linux/work/staging/.git/rebase-apply/patch:70: new blank line at EOF.
+
error: removal patch leaves file contents
error: drivers/staging/et131x/et131x_ethtool.c: patch does not apply
error: removal patch leaves file contents
error: drivers/staging/et131x/et131x_initpci.c: patch does not apply
error: removal patch leaves file contents
error: drivers/staging/et131x/et131x_isr.c: patch does not apply
error: removal patch leaves file contents
error: drivers/staging/et131x/et131x_netdev.c: patch does not apply
Patch failed at 0001 staging: et131x: Put all .c files into one big file
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".



Your patch is in the mbox called '../s2' above.

Care to resend it with the file actually deleted?  How are you
generating this patch?

And, when you resend the series, don't put the [RESEND] in the subject,
I had to edit that out in order to apply them properly (which turned out
to be a waste of time due to this patch not applying...)

thanks,

greg k-h
