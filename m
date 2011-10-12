Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1JLOxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:53:35 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35579 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473Ab1JLOxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:53:33 -0400
X-Sasl-enc: CiXpZT6h/nRGCvaQo3Vg7CksB0/mT83m4W77i8h13n8X 1318431212
Date: Wed, 12 Oct 2011 08:53:25 -0600
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Re: linux-next: manual merge of the staging tree with the pm tree
Message-ID: <20111012145325.GB18777@kroah.com>
References: <20111012162805.1056a7f7fe3f1140d767a601@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012162805.1056a7f7fe3f1140d767a601@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 04:28:05PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/Kconfig between commit a3c98b8b2ede ("PM: Introduce devfreq:
> generic DVFS framework with device-specific OPPs") from the pm tree and
> commit 46a971913611 ("Staging: hv: move hyperv code out of staging
> directory") from the staging tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

The fix for this, and the drivers/Makefile file look correct, thanks.

greg k-h
