Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab1FQMjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 08:39:40 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:34989
	"EHLO CH1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758523Ab1FQMji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 08:39:38 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMXPR1-01-1Q8-02
X-M-MSG: 
Date: Fri, 17 Jun 2011 14:37:36 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: <chrish@techspecs.com>
CC: Borislav Petkov <bp@alien8.de>, <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: PROBLEM: AMD Zacate E350 shows only 2.6GB memory when 8GB
 installed
Message-ID: <20110617123736.GA18054@aftab>
References: <53e44025a84a55558f4fb1dea8642ab6.squirrel@mail.techspecs.com>
 <4DFAF9A3.6090802@ladisch.de>
 <20110617090303.GB939@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110617090303.GB939@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 05:03:03AM -0400, Borislav Petkov wrote:
> On Fri, Jun 17, 2011 at 08:52:19AM +0200, Clemens Ladisch wrote:
> > chrish@techspecs.com wrote:
> > >    I tried this on Fedora 14 and OpenSuse 11.4 and both exhibit the same
> > > behavior. 8GB is installed but only 2698476 shows available for use
> > > using "top" or "free".
> > 
> > /proc/iomem?
> > dmesg?
> 
> Also, do you have the latest BIOS? If not, can you update it? Also, can
> you try the latest upstream kernel to verify the problem still exists?

Something else you could try is update your Fedora 14 kernel since the
latest version supposedly contains a fix which is relevant to your
issue:

commit 3fdbf004c1706480a7c7fac3c9d836fa6df20d7d
Author: Andreas Herrmann <andreas.herrmann3@amd.com>
Date:   Thu Sep 30 14:32:35 2010 +0200

    x86, mtrr: Assume SYS_CFG[Tom2ForceMemTypeWB] exists on all future AMD CPUs

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

