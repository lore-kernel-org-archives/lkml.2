Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2E3HsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:48:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:23692 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090Ab2E3HsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:48:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="105748783"
Message-ID: <4FC5D04E.5040907@intel.com>
Date: Wed, 30 May 2012 15:46:22 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: gregkh <gregkh@linuxfoundation.org>,
        "Sharp, Sarah A" <sarah.a.sharp@intel.com>,
        Alan stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb/xhci: unify parameter of xhci_msi_irq
References: <1331787186.2979.71.camel@debian> <20120315145743.GA7928@kroah.com> <4F6204B7.5010908@intel.com> <20120315175608.GA6077@xanatos>
In-Reply-To: <20120315175608.GA6077@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> Is this needed in my -next tree now?  Or is it something for later?
>>
>>
>> Appreciate if it can be in -next tree. :)
>>
>>>
>>> Any reason you did not put Sarah on the To: line here?  She's the one
>>> that needs to ack it before I can accept it.
>>
>>
>> Sarah, would you like to give some comments here?
> 
> Looks fine.  I'll send a pull request to Greg with this patch after I
> verify it doesn't generate new warnings.
> 


Sarah, any further comments for this patch? :)
