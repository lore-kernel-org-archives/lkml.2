Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab1LIAGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:06:13 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45293 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252Ab1LIAFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:05:02 -0500
X-Sasl-enc: 4rkchs3aABz1nxP6pga1OfMZh3XLFqpFIrjD9a9YvLDH 1323389101
Date: Thu, 8 Dec 2011 16:01:45 -0800
From: Greg KH <greg@kroah.com>
To: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/30] Staging: comedi: fix printk line over 80 character
 issue in daqboard2000.c
Message-ID: <20111209000145.GC31036@kroah.com>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
 <1323348745-31477-6-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323348745-31477-6-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 06:22:01PM +0530, Ravishankar karkala Mallikarjunayya wrote:
> This is a patch to the daqboard2000.c file that fixes up a
> line over 80 character warning found by the checkpatch.pl tool.
> 

Your subject: is incorrect, so I can't apply this.

greg k-h
