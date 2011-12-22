Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1LVRbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:31:39 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:33021 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226Ab1LVRbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:31:37 -0500
X-Sasl-enc: +3RZQYN/JINp71/rGoQTi+l66R3t5Idi8c9J83Bby2Dg 1324575096
Date: Thu, 22 Dec 2011 09:31:29 -0800
From: Greg KH <greg@kroah.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        kurt.hackel@oracle.com, sjenning@linux.vnet.ibm.com,
        chris.mason@oracle.com
Subject: Re: [PATCH V2 1/6] drivers/staging/ramster: cluster/messaging
 foundation
Message-ID: <20111222173129.GB28856@kroah.com>
References: <20111222155050.GA21405@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222155050.GA21405@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 07:50:50AM -0800, Dan Magenheimer wrote:
> >From 93c00028709a5d423de77a2fc24d32ec10eca443 Mon Sep 17 00:00:00 2001
> From: Dan Magenheimer <dan.magenheimer@oracle.com>
> Date: Wed, 21 Dec 2011 14:01:54 -0700
> Subject: [PATCH V2 1/6] drivers/staging/ramster: cluster/messaging foundation

Why duplicate this in the email body?  That forces me to edit the
patches and remove them, please use git send-email...

> Copy cluster subdirectory from ocfs2.  These files implement
> the basic cluster discovery, mapping, heartbeat / keepalive, and
> messaging ("o2net") that ramster requires for internode communication.
> Note: there are NO ramster-specific changes yet; this commit
> does NOT pass checkpatch since the copied source files do not.

Why are you copying the files, and not just exporting the symbols you
need/want to use here?  Are you going to be able to properly track
keeping this code in sync?

Same goes for your other patch in this series that copies code, why do
that?  Are there goals to eventually not have duplicated code?  If so,
what are they, and why not mention them?

thanks,

greg k-h
