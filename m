Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2FLAHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 20:07:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:3889 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979Ab2FLAHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 20:07:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="178629139"
Message-ID: <4FD687E5.2010605@intel.com>
Date: Tue, 12 Jun 2012 08:05:57 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: gregkh <gregkh@linuxfoundation.org>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Sharp, Sarah A" <sarah.a.sharp@intel.com>,
        Alan stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb/xhci: unify parameter of xhci_msi_irq
References: <1331787186.2979.71.camel@debian> <20120315145743.GA7928@kroah.com> <4F6204B7.5010908@intel.com> <20120315175608.GA6077@xanatos> <4FC5D04E.5040907@intel.com> <4FD59AD8.1050109@intel.com> <20120611204709.GC5742@xanatos> <20120611211428.GB24904@kroah.com>
In-Reply-To: <20120611211428.GB24904@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 05:14 AM, gregkh wrote:

> On Mon, Jun 11, 2012 at 01:47:09PM -0700, Sarah Sharp wrote:
>> Hi Alex,
>>
>> This got lost in the 3.5 push, but I think it's a good candidate for
>> 3.6.  I think Greg is accepting 3.6 patches now, and I'll send this off
>> to him.
> 
> Yes, I am taking 3.6 stuff now.  In the future, once -rc1 is out, I can
> take patches for the next release at that point in time.


I see. Thanks all.

> 
> greg k-h


