Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1AGSJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 13:09:59 -0500
Received: from cantor.suse.de ([195.135.220.2]:60141 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab1AGSJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 13:09:58 -0500
Date: Fri, 7 Jan 2011 10:08:41 -0800
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] staging: hv: Removed unneeded call to
 netif_stop_queue() in hv_netvsc
Message-ID: <20110107180841.GA14093@suse.de>
References: <1294421139-18657-1-git-send-email-hjanssen@microsoft.com>
 <20110107173139.GA12343@suse.de>
 <8AFC7968D54FB448A30D8F38F259C56233F397CF@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56233F397CF@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 05:48:11PM +0000, Hank Janssen wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@suse.de]
> > Sent: Friday, January 07, 2011 9:32 AM
> > 
> > What kernel is this needed for, .37?  .38?  older than .37?
> > 
> > thanks,
> > 
> > greg k-h
> 
> This is needed for kernels 2.6.37 and newer.

Ok.

> Btw, I have not seen KVP patches that where submitted in linux next yet.
> I have not seen any other requests for changes to them, is there anything else needed for acceptance?

No, they are in my "to-apply" queue, they missed the deadline for .38,
sorry, due to the holiday break.  I'll queue them up when .38-rc1 is
out.

thanks,

greg k-h
