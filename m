Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab0FNPMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:12:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:56806 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755143Ab0FNPM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:12:27 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19CNiEil95CZnfc5UMxWqeL4eyFA9f+91HGJWl5as
	0AOfcA7hUNLo9M
From: Peter Huewe <PeterHuewe@gmx.de>
To: Mike Rapoport <mike@compulab.co.il>
Subject: Re: [PATCH] power: Rename get_current to fix build failure / name conflict
Date: Mon, 14 Jun 2010 17:12:22 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
       Wolfram Sang <w.sang@pengutronix.de>, Tejun Heo <tj@kernel.org>,
       Ryan Mallon <ryan@bluewatersys.com>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, sfr@canb.auug.org.au,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <201005130154.58459.PeterHuewe@gmx.de> <4BEB8DC0.4060808@compulab.co.il>
In-Reply-To: <4BEB8DC0.4060808@compulab.co.il>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141712.22248.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 13 Mai 2010 07:27:28 schrieb Mike Rapoport:
> Peter Huewe wrote:
> > From: Peter Huewe <peterhuewe@gmx.de>
> >
> > This patch changes the name of get_current function pointer to
> > get_battery_current to resolve a name conflict with the get_current
> > macro defined in current.h.
> >
> > This conflict resulted in a build-failure[1] for the sh4 arch
> > allyesconfig which is resolved by this patch.
> >
> > To be consistent the other function pointers (_voltage,_capacity) were
> > renamed too.
> >
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de> 
> Acked-by: Ryan Mallon <ryan@bluewatersys.com>
> Acked-by: Mike Rapoport <mike@compulab.co.il>

Unfortunately this build-failure still exists, in Linux-next and hit Linus' 
Tree :/

References:
http://kisskb.ellerman.id.au/kisskb/buildresult/2709436/
http://kisskb.ellerman.id.au/kisskb/buildresult/2687686/

Thanks,
Peter


