Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2DRJNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 05:13:51 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:60231 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2DRJNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 05:13:49 -0400
X-IronPort-AV: E=Sophos;i="4.75,441,1330905600"; 
   d="scan'208";a="11995853"
Message-ID: <1334740425.23948.157.camel@zakaz.uk.xensource.com>
Subject: Re: In tree firmware not kept up to date
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ian Jackson <Ian.Jackson@eu.citrix.com>,
        Michael Chan <mchan@broadcom.com>, David Miller <davem@davemloft.net>
Date: Wed, 18 Apr 2012 10:13:45 +0100
In-Reply-To: <20120417190322.GA3932@decadent.org.uk>
References: <1334675504.23948.99.camel@zakaz.uk.xensource.com>
	 <20120417190322.GA3932@decadent.org.uk>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-17 at 20:03 +0100, Ben Hutchings wrote:
> On Tue, Apr 17, 2012 at 04:11:44PM +0100, Ian Campbell wrote:
> > Hello,
> > 
> > What is the current policy wrt keeping the in-tree firmware updated
> > alongside the drivers?
> 
> Muddled.
> 
> > I use CONFIG_FIRMWARE_IN_KERNEL but a couple of times[0] recently this
> > has failed me because the in-tree bnx2 driver requires
> > bnx2/bnx2-mips-09-6.2.1b.fw but the tree contains
> > firmware/bnx2/bnx2-mips-09-6.2.1a.fw.ihex and not 6.2.1b.
> > 
> > Is it a bug that bnx2 was updated without adding the new firmware or is
> > a bug that the obsolete firmware is still sitting in the tree?
> 
> It's a bug that any firmware is still in-tree, but
> CONFIG_FIRMWARE_IN_KERNEL hasn't yet been made to work with a separate
> linux-firmware directory.

Thanks, so the future-proof solution is to clone and install
firmware-linux.gitwhich is currently a rather manual process but will
improve at some point.

Cheers,
Ian.

> 
> Ben.
> 
> > Ian.
> > 
> > [0] It's possible the same thing and I've just tripped over it more than
> > once now.
> 


