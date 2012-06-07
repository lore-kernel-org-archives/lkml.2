Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451Ab2FGCMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 22:12:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:29825 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756Ab2FGCMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 22:12:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="152664495"
Message-ID: <1339035207.14538.240.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH v6 2/2] x86 mce: use new printk recursion disabling
 interface
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: ShuoX Liu <shuox.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Thu, 07 Jun 2012 10:13:27 +0800
In-Reply-To: <20120606152238.GA3874@x1.osrc.amd.com>
References: <4FC2E944.6060903@intel.com>
	 <20120604171202.GA8533@x1.osrc.amd.com>
	 <1338856360.14538.220.camel@ymzhang.sh.intel.com>
	 <20120605081448.GA7097@liondog.tnic> <4FCDD72A.9030701@intel.com>
	 <4FCDD78A.3070106@intel.com> <20120605151542.GA10669@x1.osrc.amd.com>
	 <1338942965.14538.233.camel@ymzhang.sh.intel.com>
	 <4FCF155B.3090705@intel.com> <4FCF160D.8010404@intel.com>
	 <20120606152238.GA3874@x1.osrc.amd.com>
Organization: MCG
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 17:22 +0200, Borislav Petkov wrote:
> On Wed, Jun 06, 2012 at 04:34:21PM +0800, ShuoX Liu wrote:
> > From: ShuoX Liu <shuox.liu@intel.com>
> > 
> > On x86 machines, some times MCE happens just when kernel calls printk
> > to output some log info to serial console, while usually MCE module in
> > kernel is used to print out some hardware error information, such like
> > bad cache or bad memory bank. That causes printk recursion and printk
> > would omit MCE printk output.
> > 
> > We hit it when running MTBF testing on Android ATOM mobiles.
> > 
> > Here in mce_panic, we choose to disable printk recursion to make sure
> > MCE logs printed out.
> 
> Just a minor nitpick: this should say "print_mce" or you can simply
> remove the whole sentence - commit message is fine without it too.
Thanks for your very careful/detailed comments. We would make it perfect.


