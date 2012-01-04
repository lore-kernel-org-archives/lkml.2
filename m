Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab2ADXJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:09:28 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:58877 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757290Ab2ADXJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:09:22 -0500
X-Sasl-enc: TTNrN6L6NWrXrQGygzWzl/9kFYhIk77Kntw2gCvhhOaC 1325718561
Date: Wed, 4 Jan 2012 15:07:57 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the s390
 tree
Message-ID: <20120104230757.GE24583@kroah.com>
References: <20111228172611.b23752f58cc9cda66c194dc2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228172611.b23752f58cc9cda66c194dc2@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 05:26:11PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> arch/s390/kernel/smp.c between commit 83a24e329084 ("[S390] topology: get
> rid of ifdefs") from the s390 tree and commit 8a25a2fd126c ("cpu: convert
> 'cpu' and 'machinecheck' sysdev_class to a regular subsystem") from the
> driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.
> 
> I also applied the following merge fix patch (which may not be correct or
> enough) for the bits moved into topology.c:

Looks good, thanks for doing this.

greg k-h
