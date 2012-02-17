Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab2BQIvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 03:51:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:60208 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab2BQIvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 03:51:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="111348616"
Subject: Re: [PATCH] usb: enable pci MSI/MSIX in usb core
From: "Alex,Shi" <alex.shi@intel.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, stern@rowland.harvard.edu,
        Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        andiry.xu@amd.com, linux-kernel@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>, Takashi Iwai <tiwai@suse.de>,
        trenn@suse.de, linux-pci@vger.kernel.org,
        Michal Marek <MMarek@suse.com>
In-Reply-To: <4F3E0C3D.4030307@ladisch.de>
References: <1328531341-22705-1-git-send-email-alex.shi@intel.com>
	 <4F311233.9070404@intel.com> <20120207144204.GA7214@kroah.com>
	 <20120207172743.GA4780@xanatos> <20120207221317.GA6103@xanatos>
	 <1328664392.12669.233.camel@debian> <1328682430.12669.443.camel@debian>
	 <1328692300.12669.593.camel@debian>  <20120214002030.GA10364@xanatos>
	 <1329359801.12669.2872.camel@debian> <1329461087.12669.2911.camel@debian>
	 <4F3E0C3D.4030307@ladisch.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Feb 2012 16:46:58 +0800
Message-ID: <1329468418.12669.2988.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The controller driver will need to know which of the multiple MSI-X
> interrupts has been raised:
> 
> irqreturn_t (*msix_irq)(struct usb_hcd *hcd, unsigned int nr_or_index);

Actually, hcd has 2 object for msix, msix_count and msix_entries. 

Do you mean msix_count maybe smaller than we decide in hcd_setup_msix()?
Which situation will make this? 


