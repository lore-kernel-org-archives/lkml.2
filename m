Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab1AZLmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:42:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49370 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab1AZLmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:42:23 -0500
Date: Wed, 26 Jan 2011 12:42:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Luming Yu <luming.yu@intel.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: linux-next: Tree for December 20 (acpi_video)
Message-ID: <20110126114203.GA16754@elte.hu>
References: <20101220200013.df8fbc88.sfr@canb.auug.org.au>
 <20101220085340.7ba098b9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220085340.7ba098b9.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Mon, 20 Dec 2010 20:00:13 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > [The mirroring on kernel.org is running slowly]
> > 
> > Changes since 20101217:
> 
> 
> ERROR: "thermal_cooling_device_register" [drivers/acpi/video.ko] undefined!
> ERROR: "thermal_cooling_device_unregister" [drivers/acpi/video.ko] undefined!

This bug has been reported two months ago, one month ago, it has been ignored twice 
and now the bug has been pushed upstream and it's triggering there as well.

What's going on?

Thanks,

	Ingo
