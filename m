Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab1LNAus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 19:50:48 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49756 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756432Ab1LNAun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 19:50:43 -0500
X-Sasl-enc: 5QNaT8sw/l9/MBN5Vhw9aQY6zJ3OV7znys5zSGnv2MUp 1323823842
Date: Tue, 13 Dec 2011 16:48:07 -0800
From: Greg KH <greg@kroah.com>
To: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 29/29] Staging: comedi: fix printk issue in
 contec_pci_dio.c
Message-ID: <20111214004807.GB8961@kroah.com>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
 <1323667181-17252-29-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323667181-17252-29-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 10:49:41AM +0530, Ravishankar karkala Mallikarjunayya wrote:
> This is a patch to the contec_pci_dio.c file that fixes up a
> printk warning found by the checkpatch.pl tool.
> 
> Converted printks to dev_<levels> and Removed unnecessary
> printk statements.

You forgot to add to the changelog entry this text:

	Breaks the build.

which would have saved me a lot of time tracking down the patch in this
series that was causing problems.

{sigh}

Your next patch series better come with perfectly spelled changelog
entries that actually describe what the patches do, numbered properly
(none of this 30/30 crap after a 00/29 series), not break the build (is
that asking too much?) apply with no fuzz, and to help it all out, a
home made holiday bread of your choosing, as long as it's fresh, and
does not contain dried fruit bits (soaked in liquor can't hurt either.)

Otherwise I'm very tempted to just add you to my kill file, it would
save me lots of time and frustration, and likewise, I'm sure yours as
well.

Get baking,

greg k-h
