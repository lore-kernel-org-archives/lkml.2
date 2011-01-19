Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab1ASIMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 03:12:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:59808 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab1ASIMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 03:12:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,343,1291622400"; 
   d="scan'208";a="594367776"
Subject: Re: Linux 2.6.38-rc1 doesn't boot
From: Shaohua Li <shaohua.li@intel.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>,
        "Lu, Hongjiu" <hongjiu.lu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20110119074902.GA1670@gentoo.trippels.de>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
	 <20110119073905.GA1652@gentoo.trippels.de>
	 <20110119074902.GA1670@gentoo.trippels.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 16:12:46 +0800
Message-ID: <1295424766.1949.879.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 15:49 +0800, Markus Trippelsdorf wrote:
> On 2011.01.19 at 08:39 +0100, Markus Trippelsdorf wrote:
> > On 2011.01.18 at 15:54 -0800, Linus Torvalds wrote:
> > > 
> > > And as usual, report any regressions to the lists and the appropriate
> > > authorities.
> > 
> > Unfortunately 2.6.38-rc1 doesn't even boot on my machine (amd64).
> > This is caused by 86b1e8dd83cbb0f:
> >     x86: Make relocatable kernel work with new binutils
> > 
> > Reverting the commit solves the problem.
> 
> I'm running the latest binutils:
> GNU ld (Linux/GNU Binutils) 2.21.51.0.5.20110104
Hmm, reproduce it here with binutils-2.21.51.0.6-20110118
but not with GNU ld (GNU Binutils for Ubuntu) 2.20.51-system.20100908
I got this in system.map: ffffffff03514880 D jiffies_64, which looks
wrong.
looks binutils changed something again.
Have no idea, CC Lu Hongjiu.

Thanks,
Shaohua

