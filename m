Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030186Ab2GCGuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 02:50:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:28764 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab2GCGt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 02:49:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172821173"
Date: Tue, 3 Jul 2012 14:49:54 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jan Beulich <jbeulich@suse.com>, Jiri Kosina <jkosina@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: hid/Kconfig:7:error: recursive dependency detected!
Message-ID: <20120703064954.GB17367@localhost>
References: <20120703040640.GA8236@localhost>
 <20120703064407.GA4854@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120703064407.GA4854@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 08:44:07AM +0200, Henrik Rydberg wrote:
> Hi Fengguang,
> 
> > I got this error while doing randconfig test:
> > 
> >         drivers/hid/Kconfig:7:error: recursive dependency detected!
> >         drivers/hid/Kconfig:7:  symbol HID is selected by USB_HID
> >         drivers/hid/usbhid/Kconfig:4:   symbol USB_HID depends on HID
> 
> What kernel tree does this apply to? Reading through the code again
> and testing your configuration, I cannot reproduce the
> problem. Indeed, in my tree, USB_HID does not depend on HID.

Henrik, I'm testing on today's linux-next.

Thanks,
Fengguang
