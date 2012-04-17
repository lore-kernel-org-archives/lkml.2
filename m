Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab2DQTDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 15:03:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58695 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715Ab2DQTD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 15:03:29 -0400
Date: Tue, 17 Apr 2012 20:03:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Ian Jackson <Ian.Jackson@eu.citrix.com>,
        Michael Chan <mchan@broadcom.com>, David Miller <davem@davemloft.net>
Message-ID: <20120417190322.GA3932@decadent.org.uk>
References: <1334675504.23948.99.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334675504.23948.99.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: In tree firmware not kept up to date
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 04:11:44PM +0100, Ian Campbell wrote:
> Hello,
> 
> What is the current policy wrt keeping the in-tree firmware updated
> alongside the drivers?

Muddled.

> I use CONFIG_FIRMWARE_IN_KERNEL but a couple of times[0] recently this
> has failed me because the in-tree bnx2 driver requires
> bnx2/bnx2-mips-09-6.2.1b.fw but the tree contains
> firmware/bnx2/bnx2-mips-09-6.2.1a.fw.ihex and not 6.2.1b.
> 
> Is it a bug that bnx2 was updated without adding the new firmware or is
> a bug that the obsolete firmware is still sitting in the tree?

It's a bug that any firmware is still in-tree, but
CONFIG_FIRMWARE_IN_KERNEL hasn't yet been made to work with a separate
linux-firmware directory.

Ben.

> Ian.
> 
> [0] It's possible the same thing and I've just tripped over it more than
> once now.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
