Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab1JWIUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 04:20:34 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:43684 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755040Ab1JWIUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 04:20:13 -0400
X-Sasl-enc: rq7Kz5AsbF0hmCeIc2Mv8J/pvI6ASRhHhEPEx2lAfpVB 1319358012
Date: Sun, 23 Oct 2011 10:20:00 +0200
From: Greg KH <greg@kroah.com>
To: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/24] Staging: comedi: fix warning issue in pcl818.c
Message-ID: <20111023082000.GC13409@kroah.com>
References: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
 <1319091550-2558-3-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319091550-2558-3-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 11:48:49AM +0530, Ravishankar Karkala Mallikarjunayya wrote:
> This is a patch to the pcl818.c file that fixes up a warning
> found by the checkpatch.pl tool.
> Fix brace coding style and NULL initilization issue.
> Converted printks to dev_printk.
> Removed unnecessary printk statements.

That's a lot of different things all at once here.  Please only do one
"change" per patch.  So this should be split up into multiple patches.

Same goes for your other 24 patches, care to break them up as well, as
it's easier to review and verify that you got it correct.

thanks,

greg k-h
