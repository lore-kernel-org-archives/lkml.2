Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab1HWWP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:15:28 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40190 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755905Ab1HWWPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:15:16 -0400
X-Sasl-enc: 1dbDwdssA9t5Thp6AP3IgkjOraym3MOfXAvQtGAPdkoQ 1314137714
Date: Tue, 23 Aug 2011 15:07:18 -0700
From: Greg KH <greg@kroah.com>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: gregkh@suse.de, martyn.welch@ge.com, devel@driverdev.osuosl.org,
        cota@braap.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] VME Driver Fixes
Message-ID: <20110823220718.GB15721@kroah.com>
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 12:20:45PM +0200, Manohar Vanga wrote:
> A little background: I work at CERN in the device drivers section and
> we have a lot of VME crates we use in the accelerator controls. We have
> been using an in-house driver for some time now and want to slowly port
> our existing device drivers over to the kernel driver.
> 
> This set of patches adds multiple changes to the VME driver that fix
> various issues, mostly dealing with the device driver model. Some of
> these are based on the changes made by Emilio G. Cota in a previous
> LKML thread at:
> 
>     https://lkml.org/lkml/2010/10/25/480

I only applied the first patch in this series.

thanks,

greg k-h
