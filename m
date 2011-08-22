Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1HVTQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 15:16:15 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49130 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189Ab1HVTQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 15:16:14 -0400
X-Sasl-enc: z295yCvv57rC/lH9bJzDbNrmrB7WiQcvtBW1IoNEAbg4 1314040573
Date: Mon, 22 Aug 2011 12:00:44 -0700
From: Greg KH <greg@kroah.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        stefan.bader@canonical.com, stefano.stabellini@eu.citrix.com
Subject: Re: Please back-port git commit
 196cfe2ae8fcdc03b3c7d627e7dfe8c0ce7229f9 and
 89153b5cae9f40c224a5d321665a97bf14220c2c to 3.0.x
Message-ID: <20110822190044.GA16021@kroah.com>
References: <20110822152354.GA24763@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822152354.GA24763@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 11:23:54AM -0400, Konrad Rzeszutek Wilk wrote:
> Hey Greg,
> 
> I've two patches that are in Linus's upstream kernel, but I neglected to
> put the stable@kernel.org on them (duh!). Both Fedora and Ubuntu are carrying
> those two patches - but it would be nice if other distros got them.
> 
> The two patches are:
> 
> commit 196cfe2ae8fcdc03b3c7d627e7dfe8c0ce7229f9
> Author: Stefan Bader <stefan.bader@canonical.com>
> Date:   Thu Jul 14 15:30:22 2011 +0200
> 
>     xen-blkfront: Drop name and minor adjustments for emulated scsi devices
> 
> commit 89153b5cae9f40c224a5d321665a97bf14220c2c
> Author: Stefan Bader <stefan.bader@canonical.com>
> Date:   Thu Jul 14 15:30:37 2011 +0200
> 
>     xen-blkfront: Fix one off warning about name clash
> 
> Please back-port them to 3.0.x kernel. Thank you!

Now queued up.

greg k-h
