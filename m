Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab2EIOAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:00:05 -0400
Received: from relais.videotron.ca ([24.201.245.36]:62884 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab2EIN75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:59:57 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 09 May 2012 09:59:56 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Magnus Damm <magnus.damm@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "olof@lixom.net" <olof@lixom.net>
Subject: Re: [PATCH] mach-shmobile: Emma Mobile EV2 SMP prototype code
In-reply-to: <201205091345.34404.arnd@arndb.de>
Message-id: <alpine.LFD.2.02.1205090955520.21030@xanadu.home>
References: <20120509075407.5991.60556.sendpatchset@w520>
 <201205091212.08239.arnd@arndb.de> <4FAA6DE6.3040001@arm.com>
 <201205091345.34404.arnd@arndb.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, Arnd Bergmann wrote:

> FWIW, I would actually prefer merging the 'struct arm_soc_desc', 'struct
> arm_soc_smp_init_ops' and 'struct arm_soc_smp_ops' structures into a
> single 'struct smp_ops' for simplicity.

You can't easily validate correct usage of __init marked code from the 
rest if everything is pulled in the same struct.  This is why I asked 
they be split.


Nicolas
