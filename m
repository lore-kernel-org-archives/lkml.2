Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab0F3Nid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:38:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab0F3Nib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:38:31 -0400
Date: Wed, 30 Jun 2010 15:38:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Christoph Egger <siccegge@cs.fau.de>,
       Gilles Espinasse <g.esp@free.fr>, Tejun Heo <tj@kernel.org>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 3/9] Removing dead CONFIG_SIBYTE_BCM1480_PROF
In-Reply-To: <alpine.LFD.2.00.1006301431210.13070@eddie.linux-mips.org>
Message-ID: <alpine.LNX.2.00.1006301538190.13809@pobox.suse.cz>
References: <cover.1275925108.git.siccegge@cs.fau.de> <c217f4530c057f4b8030bd14459a0cb2856decde.1275925108.git.siccegge@cs.fau.de> <alpine.LNX.2.00.1006161800290.12271@pobox.suse.cz> <20100628134959.GC29229@linux-mips.org> <alpine.LNX.2.00.1006301133400.13809@pobox.suse.cz>
 <alpine.LFD.2.00.1006301431210.13070@eddie.linux-mips.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010, Maciej W. Rozycki wrote:

> > Well, still it's dead code guarded by ifdef depending on non-exsiting 
> > symbol ... I have just quickly tried to get a grip on the zbus thing, but
> 
>  You've missed...
> 
> > 	arch/mips/configs/bigsur_defconfig:CONFIG_SIBYTE_HAS_ZBUS_PROFILING=y
> > 	arch/mips/configs/sb1250-swarm_defconfig:CONFIG_SIBYTE_HAS_ZBUS_PROFILING=y
> > 	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
> > 	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
> > 	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
> > 	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
> > 	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
> > 	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
> > 	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
> 
> ... this:
> 
> 	arch/mips/sibyte/Kconfig:	config SIBYTE_TBPROF
> 	arch/mips/sibyte/Kconfig:	tristate "Support for ZBbus profiling"
> > 	arch/mips/sibyte/Kconfig:       depends on SIBYTE_HAS_ZBUS_PROFILING
> 
> ^^^ here.
> 
> > 	arch/mips/sibyte/Kconfig:config SIBYTE_HAS_ZBUS_PROFILING
> > 
> > seem to be the only occurences in the whole tree. Another unused symbol?
> 
>  Not quite so then.

Right you are, sorry for the noise.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
