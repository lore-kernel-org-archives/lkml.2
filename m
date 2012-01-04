Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab2ADXKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:10:12 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56187 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757319Ab2ADXJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:09:27 -0500
X-Sasl-enc: JCSKm6affVk+5O8rz50Y0SB9cZAlsnU+Golyp++Zdgum 1325718566
Date: Wed, 4 Jan 2012 15:08:31 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the  arm
 tree
Message-ID: <20120104230831.GH24583@kroah.com>
References: <20111228163545.7034aa9b783d46ac4b46c545@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228163545.7034aa9b783d46ac4b46c545@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 04:35:45PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> arch/arm/mach-s5pv210/common.c between commit 37775320458e ("ARM: 7252/1:
> restart: S5PV210: use new restart hook") from the arm tree and commit
> 4a858cfc9af8 ("arm: convert sysdev_class to a regular subsystem") from
> the driver-core tree (where it is called arch/arm/mach-s5pv210/cpu.c).
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Looks good, thanks.

greg k-h
