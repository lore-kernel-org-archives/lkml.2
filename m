Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab1C1DBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 23:01:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:36712 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab1C1DBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 23:01:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,252,1299484800"; 
   d="scan'208";a="409490579"
Date: Mon, 28 Mar 2011 10:59:35 +0800
From: Lu Guanqun <guanqun.lu@intel.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "Tang, Feng" <feng.tang@intel.com>,
        "meego-kernel@lists.meego.com" <meego-kernel@lists.meego.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "Fu, Michael" <michael.fu@intel.com>,
        "Wang, Xingchao" <xingchao.wang@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>, "Kp, Jeeja" <jeeja.kp@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Feng Tang <feng.tang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jekyll Lai <jekyll_lai@wistron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/2] mrst: export get_gpio_by_name() function
Message-ID: <20110328025935.GG12596@qtel.sh.intel.com>
References: <1301279360-9839-1-git-send-email-guanqun.lu@intel.com>
 <1301279360-9839-2-git-send-email-guanqun.lu@intel.com>
 <4D8FF3AE.5060003@linux.intel.com>
 <20110328104719.78740624@feng-i7>
 <4D8FF6BB.6030005@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8FF6BB.6030005@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 10:47:23AM +0800, Arjan van de Ven wrote:
> On 3/27/2011 7:47 PM, Feng Tang wrote:
> > On Mon, 28 Mar 2011 10:34:22 +0800
> > Arjan van de Ven<arjan@linux.intel.com>  wrote:
> >
> >> On 3/27/2011 7:29 PM, Lu Guanqun wrote:
> >>> Export get_gpio_by_name() function and make its name more focused.
> >>> We are doing this because currently get_gpio_by_name() is only used
> >>> by the devices exported from SFI DEVS table, but it is also useful
> >>> for other PCI devices which also use the GPIO lines, and have their
> >>> gpio infos in the SFI GPIO table.
> >>>
> >> I can't say that I like the new name... at all.
> >>
> >> what's "mid" ?
> >> what is wrong with the original name????
> >>
> > Hi Arjan,
> >
> > The original get_gpio_by_name() is static and only used in mrst.c as it's
> > mrst/mfld specific. So if we call it from a PCI driver, that name sounds
> 
> get_gpio_by_name() would be a very good generic name for a function 
> provided by the gpio layer as well.
> 
> > like a platform independent general API while it's actually mrst/mfld bound.
> > So we would show this dependency from the function name.
> that makes no sense.
> and again, what on earth is a "mid"??????????
> 

MID stands for mobile internet device.
	http://en.wikipedia.org/wiki/Mobile_Internet_device

-- 
guanqun
