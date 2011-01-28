Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1A1Pan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:30:43 -0500
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:20865 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab1A1Pal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:30:41 -0500
X-Loopcount0: from 10.175.216.250
From: <Narendra_K@Dell.com>
To: <sfr@canb.auug.org.au>
CC: <jbarnes@virtuousgeek.org>, <lenb@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        <Matt_Domsch@Dell.com>, <Charles_Rose@Dell.com>,
        <Surya_Prabhakar@Dell.com>
Date: Fri, 28 Jan 2011 07:30:36 -0800
Subject: Re: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Thread-Topic: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Thread-Index: Acu/AE/MCnXu3x9oQFu5foFPmicj4A==
Message-ID: <20110128155337.GA27642@fedora14-r610.oslab.blr.amer.dell.com>
References: <20110112203414.GA5657@fedora14-r610.oslab.blr.amer.dell.com>
 <20110112160229.7b8d82c1@jbarnes-desktop>
 <alpine.LFD.2.02.1101122217370.19754@x980>
 <20110113075556.789ac3c3@jbarnes-vaio.home>
 <20110113162755.GA5872@fedora14-r610.oslab.blr.amer.dell.com>
 <20110114154458.GA18289@fedora14-r610.oslab.blr.amer.dell.com>
 <20110115080949.62176a3c.sfr@canb.auug.org.au>
 <20110117195215.GA2708@fedora14-r610.oslab.blr.amer.dell.com>
 <20110120190459.GA30978@fedora14-r610.oslab.blr.amer.dell.com>
In-Reply-To: <20110120190459.GA30978@fedora14-r610.oslab.blr.amer.dell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.5.21 (2010-09-15)
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 12:11:50AM +0530, K, Narendra wrote:
> On Tue, Jan 18, 2011 at 12:58:48AM +0530, K, Narendra wrote:
> > On Sat, Jan 15, 2011 at 02:39:49AM +0530, Stephen Rothwell wrote:
> > > Hi Narendra,
> > > 
> > > On Fri, 14 Jan 2011 20:52:42 +0530 <Narendra_K@Dell.com> wrote:
> > > >
> > > > This patch addresses the build failure described in this thread by
> > > > compiling fs/nls/nls_base.c always into vmlinux, thus making the base
> > > > nls functions available always.
> > > 
> > > Even on platforms that don't support ACPI or DMI ...
> > > 
> > > You should really restrict this to CONFIG_ACPI || CONFIG_DMI ||
> > > CONFIG_NLS ... maybe create a CONFIG_NLS_BASE that is selected by ACPI,
> > > DMI and NLS?
> > 
> > Hi Stephen,
> > 
> > Thank you for the suggestions. 
> > 
> > I agree with your suggestion that we should compile nls_base.o
> > conditionally, only when ACPI || DMI || NLS. I have introduced a bew
> > config option CONFIG_NLS_BASE and made ACPI, DMI and NLS select it.
> > 
> > V1 -> V2:
> > 
> > 1. Conditionally compile fs/nls/nls_base.c by introducing a new config
> > option CONFIG_NLS_BASE, which is selected by (ACPI || DMI || NLS).
> > Behavior of the rest of the files under fs/nls is not changed.
> > 
> > From: Narendra K <narendra_k@dell.com>
> > Subject: [PATCH V2] Fix build failure when CONFIG_NLS is set to 'm' by allmodconfig
> 
> Hi,
> 
> Please let me know if there are any concerns with Version 2 of the patch.
> If it looks good please consider it for inclusion.

Hi Jesse,

Please let me know if there are any concerns with this patch. If it is
acceptable, please consider this for inclusion.

With regards,
Narendra K
