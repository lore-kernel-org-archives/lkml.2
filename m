Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030750Ab2COPEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:04:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:19794 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030551Ab2COPEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:04:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="117976198"
Message-ID: <4F6204B7.5010908@intel.com>
Date: Thu, 15 Mar 2012 23:03:19 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: gregkh <gregkh@linuxfoundation.org>,
        "Sharp, Sarah A" <sarah.a.sharp@intel.com>
CC: Alan stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb/xhci: unify parameter of xhci_msi_irq
References: <1331787186.2979.71.camel@debian> <20120315145743.GA7928@kroah.com>
In-Reply-To: <20120315145743.GA7928@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 10:57 PM, gregkh wrote:

> On Thu, Mar 15, 2012 at 12:53:06PM +0800, Alex Shi wrote:
>>
>> According to Felipe and Alan's comments the second parameter of irq
>> handler should be 'void *' not a specific structure pointer. 
>> So change it.
>>
>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>> ---
>>  drivers/usb/host/xhci-ring.c |    2 +-
>>  drivers/usb/host/xhci.c      |    4 ++--
>>  drivers/usb/host/xhci.h      |    2 +-
>>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> Is this needed in my -next tree now?  Or is it something for later?


Appreciate if it can be in -next tree. :)

> 
> Any reason you did not put Sarah on the To: line here?  She's the one
> that needs to ack it before I can accept it.


Sarah, would you like to give some comments here?

Thanks!

> 
> thanks,
> 
> greg k-h


