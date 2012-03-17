Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946096Ab2CQACv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 20:02:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:12259 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946023Ab2CQACM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 20:02:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="78549003"
Message-ID: <4F63D481.50202@intel.com>
Date: Sat, 17 Mar 2012 08:02:09 +0800
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


>> Sarah, would you like to give some comments here?
> 
> Looks fine.  I'll send a pull request to Greg with this patch after I
> verify it doesn't generate new warnings.
> 
> Sarah Sharp


Thanks!
