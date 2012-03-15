Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924Ab2COOjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:39:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:51918 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab2COOjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:39:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="121310692"
Message-ID: <4F61FF28.8000505@intel.com>
Date: Thu, 15 Mar 2012 22:39:36 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh <gregkh@linuxfoundation.org>, sarah.a.sharp@linux.intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb/core: skip unnecessary line IRQ request for USB3
References: <Pine.LNX.4.44L0.1203151025300.1366-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1203151025300.1366-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> This is not a good idea.  What happens if some USB-3 controller 
> (perhaps a non-xHCI USB-3 controller) doesn't use MSI?
> 


current usb3 driver just xhci. but sure it need to modify if non-xhci
usb pops up.

> The right way to avoid registering a legacy interrupt handler is to 
> call usb_add_hcd() with irqnum equal to 0.


a good trick! will try it tomorrow.

> 
> Alan Stern
> 




