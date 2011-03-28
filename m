Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1C1Fu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 01:50:58 -0400
Received: from kroah.org ([198.145.64.141]:49631 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab1C1Fu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 01:50:56 -0400
Date: Sun, 27 Mar 2011 22:50:24 -0700
From: Greg KH <greg@kroah.com>
To: Lu Guanqun <guanqun.lu@intel.com>
Cc: meego-kernel@lists.meego.com, alan@linux.intel.com, arjan@linux.intel.com,
        fengguang.wu@intel.com, feng.tang@intel.com, michael.fu@intel.com,
        xingchao.wang@intel.com, vinod.koul@intel.com, jeeja.kp@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Feng Tang <feng.tang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jekyll Lai <jekyll_lai@wistron.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 1/2] mrst: export get_gpio_by_name() function
Message-ID: <20110328055024.GA27949@kroah.com>
References: <1301279360-9839-1-git-send-email-guanqun.lu@intel.com>
 <1301279360-9839-2-git-send-email-guanqun.lu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301279360-9839-2-git-send-email-guanqun.lu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 10:29:19AM +0800, Lu Guanqun wrote:
> Export get_gpio_by_name() function and make its name more focused.  We are
> doing this because currently get_gpio_by_name() is only used by the devices
> exported from SFI DEVS table, but it is also useful for other PCI devices which
> also use the GPIO lines, and have their gpio infos in the SFI GPIO table.

As others pointed out, don't change the name of this function.

Also, this is only needed by the one staging driver, right?

thanks,

greg k-h
