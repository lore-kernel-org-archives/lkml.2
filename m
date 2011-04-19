Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab1DSIoC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:44:02 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:63477 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab1DSIn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:43:59 -0400
X-Loopcount0: from 10.175.216.251
From: <Narendra_K@Dell.com>
To: <mingo@elte.hu>
CC: <viro@zeniv.linux.org.uk>, <jbarnes@virtuousgeek.org>, <mjg@redhat.com>,
        <sfr@canb.auug.org.au>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <Shyam_Iyer@Dell.com>,
        <Matt_Domsch@Dell.com>, <Charles_Rose@Dell.com>,
        <Jordan_Hargrave@Dell.com>
Date: Tue, 19 Apr 2011 01:43:53 -0700
Subject: RE: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Thread-Topic: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Thread-Index: Acv+WADOASDkhDDqSBaf8InHTEVvdgAFLQMw
Message-ID: <E31FB011129F30488D5861F3839049151DA2EC035A@BLRX7MCDC201.AMER.DELL.COM>
References: <20110223131536.GA16707@fedora14-r610.blr.amer.dell.com>
 <20110419060641.GA26624@elte.hu>
In-Reply-To: <20110419060641.GA26624@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Ingo Molnar [mailto:mingo@elte.hu]
> Sent: Tuesday, April 19, 2011 11:37 AM
> To: K, Narendra
> Cc: viro@zeniv.linux.org.uk; jbarnes@virtuousgeek.org; mjg@redhat.com;
> sfr@canb.auug.org.au; linux-kernel@vger.kernel.org; linux-
> next@vger.kernel.org; Iyer, Shyam; Domsch, Matt; Rose, Charles; Hargrave,
> Jordan
> Subject: Re: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
> allmodconfig
> 
> 
> * Narendra_K@Dell.com <Narendra_K@Dell.com> wrote:
> 
> > This patch fixes the following build breakage introduced by the patch
> > '[PATCH V3] Export ACPI _DSM provided firmware instance number and
> > string to sysfs'.
> >
> > drivers/built-in.o: In function `T.647':
> > pci-label.c:(.text+0x28514): undefined reference to `utf16s_to_utf8s'
> 
> btw., this build bug still triggers upstream with .39-rc4 - any plans on when
> this regression will be fixed?

Hi,

The commit  8a226e00eeed8db843d4a580013a49ae3559bcd7 in linux-next fixes it (PCI: pci-label: Fix build failure when CONFIG_NLS is set to 'm' by allmodconfig).
It is not in .39-rc4.

With regards,
Narendra K

