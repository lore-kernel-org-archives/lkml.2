Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab1LIAFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:05:05 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43677 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156Ab1LIAFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:05:01 -0500
X-Sasl-enc: zR2+tHXO2rQq3JJHgZhSBl/FLKMYrs0AAz/fpS1EULZs 1323389100
Date: Thu, 8 Dec 2011 16:01:13 -0800
From: Greg KH <greg@kroah.com>
To: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/30] Staging: comedi: fix printk issue in daqboard2000.c
Message-ID: <20111209000113.GB31036@kroah.com>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
 <1323348745-31477-4-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323348745-31477-4-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 06:21:59PM +0530, Ravishankar karkala Mallikarjunayya wrote:
> This is a patch to the daqboard2000.c file that fixes up a
> printk warning found by the checkpatch.pl tool.
> 
> Removed ifdef DEBUG_EEPROM.

Are you sure you can?

> Converted printks to pr_<levels>.

Again, please use dev_dbg().

greg k-h
