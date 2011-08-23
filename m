Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab1HWTCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:02:09 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45840 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755749Ab1HWTBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:01:48 -0400
X-Sasl-enc: YtNt3IGjegOdraf73iLP35ABfcC+f5qzKIBBKY6L3pJz 1314126106
Date: Tue, 23 Aug 2011 11:53:22 -0700
From: Greg KH <greg@kroah.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        Ravishankar <ravishankarkm32@gmal.com>, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH] Staging: comedi: fix printk issue in adv_pci1710.c
Message-ID: <20110823185322.GA11386@kroah.com>
References: <1313761468-8055-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313761468-8055-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 09:44:28AM -0400, Ravishankar wrote:
> From: Ravishankar <ravi.shankar@greenturtles.in>
> 
> This is a patch to the adv_pci1710.c file that fixes up a printk warning found by the checkpatch.pl tool
> 
> Signed-off-by: Ravishankar <ravishankarkm32@gmal.com>

Due to the huge number of different revisions of your patches, and the
lack of any response from you based on the review comments except to
send more patches, I've dropped everything from you that was in my
to-apply queue.

Can you please resend everything that I have not applied, that is still
applicable, after handling the review comments of the numerous people
who took their time to try to help you out here?  To ignore them is not
nice at all.

thanks,

greg k-h
