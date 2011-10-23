Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab1JWIUP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 04:20:15 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:53415 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754978Ab1JWIUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 04:20:10 -0400
X-Sasl-enc: Za+li9w0gwKP78WRUi2v+zI5LYZ+ouZ1gMs5anmFfcJ0 1319358009
Date: Sun, 23 Oct 2011 10:18:11 +0200
From: Greg KH <greg@kroah.com>
To: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/24] Staging: comedi: fix printk issue in das6402.c
Message-ID: <20111023081811.GA13409@kroah.com>
References: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 11:48:47AM +0530, Ravishankar Karkala Mallikarjunayya wrote:
> This is a patch to the das6402.c file that fixes up a printk warning
> found by the checkpatch.pl tool.
> Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Why is this needed?  dev_printk() doesn't use it, right?  So it
shouldn't be needed here, or am I missing something?

greg k-h
