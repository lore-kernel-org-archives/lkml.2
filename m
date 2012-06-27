Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab2F0LtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 07:49:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:58632 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab2F0LtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 07:49:06 -0400
Message-ID: <1340797732.3732.46.camel@pasglop>
Subject: Re: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
Cc: linuxppc-dev@lists.ozlabs.org, scottwood@freescale.com,
        linux-kernel@vger.kernel.org, leoli@freescale.com
Date: Wed, 27 Jun 2012 21:48:52 +1000
In-Reply-To: <20120627102138.GB10476@localhost.localdomain>
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
	 <1340748634.3732.27.camel@pasglop>
	 <20120627102138.GB10476@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 18:21 +0800, Zhao Chenhui wrote:
> > What's that CONFIG option for ?
> > 
> > Cheers,
> > Ben.
> 
> This option is to guard the timebase sync routines. It is selected
> when KEXEC or HOTPLUG_CPU is enabled on Freescale Book-E platforms.

Any reason not to just make it unconditional ? That sort of config
option tend to just confuse things and make bug reports harder to sort
out.... Also you decrease your test coverage.

Cheers,
Ben.

