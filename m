Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab2EKJgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 05:36:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:36750 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758155Ab2EKJgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 05:36:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164880285"
Date: Fri, 11 May 2012 11:45:31 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: NeilBrown <neilb@suse.de>
Cc: Felipe Balbi <balbi@ti.com>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/4] twl4030_charger improvements.
Message-ID: <20120511094531.GF1214@sortiz-mobl>
References: <20120508213518.2844.95446.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120508213518.2844.95446.stgit@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On Wed, May 09, 2012 at 07:40:39AM +1000, NeilBrown wrote:
> Hi,
>  this series is a resend of a previous submission with some
>  contentious patches removed and extra maintainers added.
> 
>  They allow the twl4030 to charge the backup battery (voltage and
>  current configured in board file) and allow the charger to continue
>  charging while the USB PHY is otherwise idle (no gadget module
>  loaded, or host in suspend-to-RAM).
> 
>  Anton: could you take the first three?  Do I need to split the third
>    patch into an 'MFD' part for Samuel and a power_supply part for you?
I'm fine with Anton taking patch #3 as it is.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
