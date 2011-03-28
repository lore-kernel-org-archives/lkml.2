Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1C1GXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 02:23:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:57379 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab1C1GXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 02:23:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,252,1299484800"; 
   d="scan'208";a="409550258"
Date: Mon, 28 Mar 2011 14:25:18 +0800
From: Feng Tang <feng.tang@intel.com>
To: Greg KH <greg@kroah.com>
CC: "Lu, Guanqun" <guanqun.lu@intel.com>,
        "meego-kernel@lists.meego.com" <meego-kernel@lists.meego.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "Fu, Michael" <michael.fu@intel.com>,
        "Wang, Xingchao" <xingchao.wang@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>, "Kp, Jeeja" <jeeja.kp@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Feng Tang <feng.tang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jekyll Lai <jekyll_lai@wistron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/2] mrst: export get_gpio_by_name() function
Message-ID: <20110328142518.2af6b2e2@feng-i7>
In-Reply-To: <20110328055024.GA27949@kroah.com>
References: <1301279360-9839-1-git-send-email-guanqun.lu@intel.com>
	<1301279360-9839-2-git-send-email-guanqun.lu@intel.com>
	<20110328055024.GA27949@kroah.com>
Organization: intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, 28 Mar 2011 13:50:24 +0800
Greg KH <greg@kroah.com> wrote:

> On Mon, Mar 28, 2011 at 10:29:19AM +0800, Lu Guanqun wrote:
> > Export get_gpio_by_name() function and make its name more focused.
> > We are doing this because currently get_gpio_by_name() is only used
> > by the devices exported from SFI DEVS table, but it is also useful
> > for other PCI devices which also use the GPIO lines, and have their
> > gpio infos in the SFI GPIO table.
> 
> As others pointed out, don't change the name of this function.
Yes, will keep it in mind

> 
> Also, this is only needed by the one staging driver, right?
Yes, currently it is only needed by the intel_sst driver in stating.

Thanks,
Feng
