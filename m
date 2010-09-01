Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab0IAWGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 18:06:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:33324 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058Ab0IAWGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 18:06:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,306,1280732400"; 
   d="scan'208";a="319820364"
Subject: Re: [PATCH] [arch-x86] Allow SRAT integrity check to be skipped
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: "rdunlap@xenotime.net" <rdunlap@xenotime.net>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <41621.148.87.67.139.1283378664.squirrel@www.xenotime.net>
References: <20100901213318.19353.54619.stgit@localhost.localdomain>
	 <41621.148.87.67.139.1283378664.squirrel@www.xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 15:11:38 -0700
Message-ID: <1283379098.28591.20.camel@pjaxe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 15:04 -0700, rdunlap@xenotime.net wrote:
> On Wed, September 1, 2010 2:33 pm, Peter P Waskiewicz Jr wrote:
> > Documentation/x86/x86_64/boot-options.txt |    4 ++++
> > arch/x86/mm/srat_64.c                     |   20 +++++++++++++++++--- 2
> > files changed, 21 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c index
> > f9897f7..8719472 100644 --- a/arch/x86/mm/srat_64.c
> > +++ b/arch/x86/mm/srat_64.c
> > @@ -351,6 +351,15 @@ int __init acpi_get_nodes(struct bootnode *physnodes)
> >  return ret; }
> >
> >
> > +int srat_bypass_bios = 0;
> 
> static int srat_bypass_bios;
> 
> Don't need to init to 0.

I'll fix and send a second version.  Thanks Randy.

-PJ

