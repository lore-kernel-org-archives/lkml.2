Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab0ITNDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 09:03:01 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:28992 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab0ITNDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 09:03:00 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L91QQO-01-3YK-02
X-M-MSG: 
Date: Mon, 20 Sep 2010 14:59:29 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Doug Thompson <norsk5@yahoo.com>
Subject: Re: [RFC 3/6] x86, NMI, Rename memory parity error to PCI SERR
 error
Message-ID: <20100920125929.GA5349@kryptos.osrc.amd.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <1284087065-32722-3-git-send-email-ying.huang@intel.com>
 <20100913010248.GH21909@erda.amd.com>
 <1284343326.3269.70.camel@yhuang-dev.sh.intel.com>
 <20100916081806.GV13563@erda.amd.com>
 <1284682105.32373.11.camel@yhuang-dev>
 <20100917091454.GL13563@erda.amd.com>
 <1284855635.32373.298.camel@yhuang-dev>
 <20100920080010.GM13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100920080010.GM13563@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>
Date: Mon, Sep 20, 2010 at 10:00:10AM +0200

(adding Doug to CC)

> On 18.09.10 20:20:35, Huang Ying wrote:
> > > If I am not wrong the only real functional change is to rip out the
> > > edac handler. So, just introduce the final names with your renaming in
> > > patch #1 (and maybe make a comment in the commit message or change
> > > patch order).
> > 
> > If I merge the 1/6 and 3/6, can you suggest a patch subject, "Add symbol
> > definition for NMI magic constants and rename memory parity to PCI
> > SERR"?
> 
> Yes, maybe we make the edac change a separate one.

What is more, there are a bunch of edac drivers using the PCI SERR nmi
as a means to check for PCI errors so we shouldn't be removing it now,
should we?

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.

