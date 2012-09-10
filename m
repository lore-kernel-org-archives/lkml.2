Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab2IJWg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 18:36:57 -0400
Received: from smtp-fw-31001.amazon.com ([207.171.178.25]:50278 "EHLO
	smtp-fw-31001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab2IJWgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 18:36:55 -0400
X-IronPort-AV: E=Sophos;i="4.80,400,1344211200"; 
   d="scan'208";a="292639195"
Date: Mon, 10 Sep 2012 15:36:45 -0700
From: Matt Wilson <msw@amazon.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "Justin M. Forbes" <jmforbes@linuxtx.org>, Jan Beulich <JBeulich@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>, <xen-devel@lists.xen.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH/RFC] Fix xsave bug on older Xen hypervisors
Message-ID: <20120910223644.GC22357@u002268147cd4502c336d.ant.amazon.com>
References: <1347018043-21252-1-git-send-email-stefan.bader@canonical.com>
 <504A05B00200007800099C7B@nat28.tlf.novell.com>
 <5049F4E9.9050306@canonical.com>
 <504A1A950200007800099D4C@nat28.tlf.novell.com>
 <20120907142251.GA20096@linuxtx.org>
 <20120907145433.GA5378@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120907145433.GA5378@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 10:54:33AM -0400, Konrad Rzeszutek Wilk wrote:
> 
> Sure. Jan is asking though for actual confirmation that the upstream kernel
> does indeed go belly up without a workaround.
> And whether this patch (which I would did since Canonical is carrying it) does
> fix the issue.
> 
> I am still a newbie on the Amazon EC2 upload your kernel thing (hint, would
> appreciate somebody taking this patch and trying it out).

For what it's worth, that's super easy these days. All modern Linux
AMIs on EC2 should be using PV-GRUB. Just adjust the GRUB 0.97
configuration file in /boot/grub/menu.lst to point at your new kernel.

I have seen some OEL AMIs that, for some reason, have a partition
table and /boot on a separate partition. This means that the
configuration file is in /boot/boot/grub/menu.lst.

Matt
