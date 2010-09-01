Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab0IAIye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 04:54:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34393 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab0IAIyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 04:54:32 -0400
Date: Wed, 1 Sep 2010 09:54:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Eric Paris <eparis@redhat.com>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ksummit-2010-discuss@lists.linux-foundation.org" 
	<ksummit-2010-discuss@lists.linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [Ksummit-2010-discuss] [PATCH] MAINTAINERS: add U: for URL of
	todo list, add RCU todo list
Message-ID: <20100901085422.GA29145@sirena.org.uk>
References: <1282839933.8133.11.camel@mulgrave.site> <20100826092923.4bdbea69.rdunlap@xenotime.net> <20100826093838.74ab9958@infradead.org> <1283275388.1377.216.camel@gandalf.stny.rr.com> <20100831230213.GG2421@linux.vnet.ibm.com> <1283296622.1377.765.camel@gandalf.stny.rr.com> <987664A83D2D224EAE907B061CE93D53015D9B2445@orsmsx505.amr.corp.intel.com> <1283298391.1797.100.camel@Joe-Laptop> <1283300616.3284.213.camel@dhcp231-106.rdu.redhat.com> <1283301257.1797.105.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283301257.1797.105.camel@Joe-Laptop>
X-Cookie: You can't take damsel here now.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 05:34:17PM -0700, Joe Perches wrote:
> On Tue, 2010-08-31 at 20:23 -0400, Eric Paris wrote:

> > If I just downloaded a big tar ball and started trolling randomly
> > through the source how am I going to know what the MAINTAINERS file is?

> I think that tarball trolling is pretty rare these days.

My experience is that there's an awful lot of people working with
whatever kernel has been provided by their vendor rather than getting
kernels direct from kernel.org and they tend to only look as far as the
tarball (or other package) they got.

> Any one know the statistics for kernel git traffic vs tarballs?

The kernel.org traffic is going to miss people using distribution or
other non kernel.org traffic so might be a bit misleading.
