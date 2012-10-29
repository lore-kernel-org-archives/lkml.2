Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156Ab2J2Nui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:50:38 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:57482 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759072Ab2J2Nuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:50:37 -0400
Date: Mon, 29 Oct 2012 07:36:09 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 0/5] zynq subarch cleanups
Message-ID: <20121029133609.GE5190@beefymiracle.amer.corp.natinst.com>
References: <cover.1351466765.git.josh.cartwright@ni.com>
 <5c2911d7-f753-4d9f-b8d8-3bf011d58e52@TX2EHSMHS014.ehs.local>
MIME-Version: 1.0
In-Reply-To: <5c2911d7-f753-4d9f-b8d8-3bf011d58e52@TX2EHSMHS014.ehs.local>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/29/2012 08:36:01 AM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/29/2012 08:36:01 AM,
	Serialize complete at 10/29/2012 08:36:01 AM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-29_01:2012-10-26,2012-10-29,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 07:24:16AM +0000, Michal Simek wrote:
> Hi Josh,
>
> > Michal-
> >
> > Here is a v5 of the zynq cleanup patchset that addresses your
> > feedback.  I've intentionally left patches 4 and 5 in the set until
> > we figure out the appropriate way to get them in tree (feel free to
> > just apply 1-3)
>
> I am ok to pick just several patches from your patchset. But this is
> no definitely good working style. Not expert for submission process
> but I think that if there is one broken patch maintainer shouldn't
> apply it.  Can someone else check this?

It turns out that with the change to patch 5 to map the uart to a known
working address (instead of VMALLOC_END - 0x1000), patch 4 isn't needed,
and as such can be dropped.  (I didn't realize this until this morning
until I had saw you had applied 1-3,5 to your tree, but not 4).

So, for what it's worth, you've applied all of the relevant patches for
this patchset.

  Josh
