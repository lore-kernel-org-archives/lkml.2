Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab1FGWY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:24:56 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43152 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174Ab1FGWYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:24:55 -0400
X-Sasl-enc: oXSjhLcsEoP6GMx/SxVvxKKX/Ru9vW9+bIf5GKnxBU0k 1307485494
Date: Tue, 7 Jun 2011 15:24:44 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: Re: [PATCH 12/49] Staging: hv: storvsc: Add a DMI signature to
 support auto-loading
Message-ID: <20110607222444.GA26968@kroah.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-12-git-send-email-kys@microsoft.com>
 <20110606231259.GA18222@infradead.org>
 <6E21E5352C11B742B20C142EB499E0480813D84D@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20110607185813.GA3531@kroah.com>
 <6E21E5352C11B742B20C142EB499E0480813DD09@TK5EX14MBXC122.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0480813DD09@TK5EX14MBXC122.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 10:19:06PM +0000, KY Srinivasan wrote:
> Thanks Greg. Can you give me some pointers here as to what needs to be
> done here. Looking at the code for virtio, it looks like I would need to add stuff
> to scripts/mod/file2alias.c as well as to include/linux/mod_devicetable.h. Will you
> accept patches for these files to support an ID space for Hyper-V vmbus drivers.

Yes, I will take patches for those files to implement this.

Along with those files, you also need a way to tell userspace that new
UIDS are found before the individual drivers are loaded.  Hopefully you
can do that now, but if not, it will need to be implemented.

thanks,

greg k-h
