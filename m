Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939Ab0GBPbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 11:31:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:49446 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758912Ab0GBPbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 11:31:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,526,1272870000"; 
   d="scan'208";a="582219641"
Date: Fri, 2 Jul 2010 17:31:10 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
       linus.walleij@stericsson.com, l.fu@pengutronix.de
Subject: Re: [PATCHv4 1/3] mfd: add STMPE I/O Expander support
Message-ID: <20100702153109.GC2960@sortiz-mobl>
References: <20100701123426.GD4092@pengutronix.de>
 <1278069730-4425-1-git-send-email-rabin.vincent@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278069730-4425-1-git-send-email-rabin.vincent@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rabin,

On Fri, Jul 02, 2010 at 04:52:08PM +0530, Rabin Vincent wrote:
> Add support for the STMPE family of I/O Expanders from
> STMicroelectronics.  These devices include upto 24 gpios and a varying
> selection of blocks, including PWM, keypad, and touchscreen controllers.
> This patch adds the MFD core.
Looks good now, all 3 patches applied. Thanks a lot for your efforts.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
