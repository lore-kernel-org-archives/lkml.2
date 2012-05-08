Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab2EHNYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:24:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58144 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754810Ab2EHNYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:24:15 -0400
X-Sasl-enc: 5cuoHkV5ByK8LZYJOX9enkD1GETIL+Vg1y+PR4CjNopd 1336483453
Date: Tue, 8 May 2012 06:24:12 -0700
From: Greg KH <greg@kroah.com>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: mchehab@redhat.com, bp@amd64.org, tony.luck@intel.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V3] edac: avoid mce decoding crash after edac driver
 unloaded
Message-ID: <20120508132412.GB5569@kroah.com>
References: <1336374233-11482-1-git-send-email-gong.chen@linux.intel.com>
 <1336395950-12430-1-git-send-email-gong.chen@linux.intel.com>
 <20120507155202.GA3934@kroah.com>
 <4FA8C44A.3070700@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA8C44A.3070700@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 02:59:22PM +0800, Chen Gong wrote:
> ...
> > 
> > <formletter>
> > 
> > This is not the correct way to submit patches for inclusion in the
> >  stable kernel tree.  Please read 
> > Documentation/stable_kernel_rules.txt for how to do this properly.
> > 
> > </formletter> -- To unsubscribe from this list: send the line 
> > "unsubscribe linux-edac" in the body of a message to 
> > majordomo@vger.kernel.org More majordomo info at 
> > http://vger.kernel.org/majordomo-info.html
> > 
> 
> Hi, Greg
> 
> Do you mean I need to add some information in my patch as below:
> 
> Cc: <stable@vger.kernel.org> # 3.3.y:
> Cc: <stable@vger.kernel.org> # 3.2.y: 3653ada: x86, mce: Add wrappers
> Cc: <stable@vger.kernel.org> # 3.2.y:
> 
> 
> For 3.3.y, commit 3653ada has been there so it is not necessary. Is it
> OK to send one patch to two -stable trees?

Yes, if you just add the line once, it will be applied to all
appliciable stable trees when it is accepted into Linus's tree.

greg k-h
