Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab0F2RiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 13:38:18 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:46397 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268Ab0F2RiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 13:38:15 -0400
Date: Mon, 28 Jun 2010 14:49:59 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Christoph Egger <siccegge@cs.fau.de>, Gilles Espinasse <g.esp@free.fr>,
       Tejun Heo <tj@kernel.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 3/9] Removing dead CONFIG_SIBYTE_BCM1480_PROF
Message-ID: <20100628134959.GC29229@linux-mips.org>
References: <cover.1275925108.git.siccegge@cs.fau.de>
 <c217f4530c057f4b8030bd14459a0cb2856decde.1275925108.git.siccegge@cs.fau.de>
 <alpine.LNX.2.00.1006161800290.12271@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1006161800290.12271@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 06:00:59PM +0200, Jiri Kosina wrote:

> On Wed, 9 Jun 2010, Christoph Egger wrote:
> 
> > CONFIG_SIBYTE_BCM1480_PROF doesn't exist in Kconfig, therefore removing all
> > references for it from the source code.
> 
> The patch isn't present in linux-next as of today. I have applied it to my 
> tree, thanks.

Nack.  This only need to be rewired to use the ZBus profiler just like
the SB1250 already does.  It's the virtually same hardware after all!

  Ralf
