Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab0EZFxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 01:53:09 -0400
Received: from mga06.intel.com ([134.134.136.21]:5094 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752426Ab0EZFxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 01:53:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,302,1272870000"; 
   d="scan'208";a="521305744"
Date: Wed, 26 May 2010 09:23:57 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@CS.Princeton.EDU>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Greg KH <greg@kroah.com>,
       "stable@kernel.org" <stable@kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Song, Youquan" <youquan.song@intel.com>
Subject: Re: [stable] Boot failure with 2.6.27.46 on Xeon E5620 (Westmere EP)
Message-ID: <20100526132357.GA26728@youquan-linux.bj.intel.com>
References: <000954C6-B4AC-4FD8-BA3B-C3B199C7607F@CS.Princeton.EDU> <20100525155307.GA7453@kroah.com> <620C3556-2708-4704-90F3-37DDEF1A404E@CS.Princeton.EDU> <20100525205123.GA14993@kroah.com> <1274833451.2892.574.camel@sbs-t61.sc.intel.com> <DD6ACA75-527D-406D-971B-64F042E0ED26@CS.Princeton.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DD6ACA75-527D-406D-971B-64F042E0ED26@CS.Princeton.EDU>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I can't think of any known issues in 2.6.27 that can lead to this kind
> > of boot failure on WSM-EP. Caglar, It will be nice if you can do git
> > bisect between working and non-working kernels.
> 
> Sure, I'll try to boot those with plain 2.6.27 to see but please note that it's going to be little time consuming. For each one I have to create a custom boot image for them to download and test (a.k.a. don't expect to hear from me soon :))

Hi Caglar,

What's the microcode version? Get by "dmesg | grep microcode" if you
success boot other version of kernel.
Can you try to disable C-state(C6) in BIOS before your boot 2.6.27?

Thanks
-Youquan
