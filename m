Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab1JQWMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:12:34 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:33808 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753326Ab1JQWMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:12:33 -0400
X-Sasl-enc: /yShElESqaLyC7uskaR/ZPTUUgeHDGSWksoPYGB1l8OF 1318889552
Date: Mon, 17 Oct 2011 15:07:55 -0700
From: Greg KH <greg@kroah.com>
To: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH 5/5] Staging: comedi: fix printk issue in c6xdigio.c
Message-ID: <20111017220755.GB26535@kroah.com>
References: <1318488485-15318-1-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318488485-15318-1-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 12:18:05PM +0530, Ravishankar Karkala Mallikarjunayya wrote:
> This is a patch to the c6xdigio.c file that fixes up a printk warning
> found by the checkpatch.pl tool
> 
> Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
> ---

I have no idea how many patches are in this series as you started with
1/4, then properly went 2/4, 3/4, and 4/4.

But, you then followed up with 5/5, 6/6, 7/7 and so on up to 13/13, yet
if I am to believe the numbering, I missed a whole bunch of the patches.

So, care to resend them properly so I know that I got them all?

greg k-h
