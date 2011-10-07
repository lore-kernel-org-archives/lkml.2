Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1JGUCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:02:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54571 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754089Ab1JGUCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:02:46 -0400
Message-ID: <1318017765.11045.12.camel@Joe-Laptop>
Subject: Re: [PATCH v3] omap: dmtimer: convert printk to pr_err
From: Joe Perches <joe@perches.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: =?ISO-8859-1?Q?V=EDctor?= Manuel =?ISO-8859-1?Q?J=E1quez?=
	 Leal <vjaquez@igalia.com>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Timo Teras <timo.teras@solidboot.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 07 Oct 2011 13:02:45 -0700
In-Reply-To: <20111007195714.GB26805@n2100.arm.linux.org.uk>
References: <20111006201827.GT6324@atomide.com>
	 <1317977417-17874-1-git-send-email-vjaquez@igalia.com>
	 <20111007092243.GC27281@n2100.arm.linux.org.uk>
	 <1318009239.1644.38.camel@Joe-Laptop>
	 <20111007191822.GA26805@n2100.arm.linux.org.uk>
	 <1318016901.11045.9.camel@Joe-Laptop>
	 <20111007195714.GB26805@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 20:57 +0100, Russell King - ARM Linux wrote:
> On Fri, Oct 07, 2011 at 12:48:21PM -0700, Joe Perches wrote:
> > I think it needs to be done subsystem by subsystem,
> > arch by arch, as maintainers accept.
> Agreed - but doing one instance here, maybe another instance somewhere
> else, and come the merge window having several of these patches
> scattered around with no real coherent "this is what we're doing, and
> its all done for this bit of the tree" kind of story is not the way to
> do it.
> It would be good to get core code done, or a sub-arch, and then say
> "we're not accepting any patch which re-introduces the problem"...
> It's a little late in the cycle for that now though.

Well, if you want it done for arch/arm, just let me
know when it would be convenient for you and I'll
do them all as a single patch.



