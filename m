Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab0JHPJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 11:09:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:41641 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758499Ab0JHPJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 11:09:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,303,1283756400"; 
   d="scan'208";a="665465800"
Date: Fri, 8 Oct 2010 11:09:54 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Brokhman Tatyana <tlinder@codeaurora.org>
Cc: Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH v3] usb: usb3.0 ch9 definitions
Message-ID: <20101008150954.GA18531@linux.intel.com>
References: <1286476470-15265-1-git-send-email-tlinder@codeaurora.org>
 <20101007210919.GA26660@suse.de>
 <d1949f2ff70c005def81a7dd6d12f2ca.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1949f2ff70c005def81a7dd6d12f2ca.squirrel@www.codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 05:35:40AM -0700, Brokhman Tatyana wrote:
> >> + */
> >> +#define USB_DEVICE_U1_ENABLE	48	/* dev may initiate U1 transition */
> >> +#define USB_DEVICE_U2_ENABLE	49	/* dev may initiate U2 transition*/
> >> +#define USB_DEVICE_LTM_ENABLE	50	/* dev may send LTM*/
> >> +#define USB_INTRF_FUNC_SUSPEND	0	/* function suspend*/

Missing space before the '*/' on these three lines.

> > __le16?  I'm guessing these fields haven't actually been used for
> > anything?
> 
> Actually __bU2DevExitLat is not bitwise field so it can remain __u16. And
> no, their values have been used for nothing but testing the descriptor.

The __le16 isn't about bitfields.  It's about the fact that the bytes
are stored in little-endian form.

