Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab1IJAmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 20:42:53 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:49344 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754217Ab1IJAmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 20:42:52 -0400
X-Sasl-enc: 6SGrCaSoD1Esfb4tV66B+jFJa/4BTtPPYH+RCRtLgqSD 1315615369
Date: Fri, 9 Sep 2011 17:41:38 -0700
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] zram: Simplify zram disk resizing interface
Message-ID: <20110910004138.GA27110@kroah.com>
References: <1315609264-13632-1-git-send-email-ngupta@vflare.org>
 <1315609264-13632-5-git-send-email-ngupta@vflare.org>
 <20110909231128.GA24604@kroah.com>
 <4E6AAB81.2010600@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6AAB81.2010600@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 08:12:49PM -0400, Nitin Gupta wrote:
> On 09/09/2011 07:11 PM, Greg KH wrote:
> 
> > "simplify" it in what way?
> > 
> > What just got changed, and why, and did it just break any documentation?
> > 
> 
> 
> Its simplification in the sense that earlier we had to be pass total RAM
> size in bytes when setting zram disksize using zram_set_disksize()
> which is not intuitive.  The replaced version instead just requires
> the new size to be set which seems to make more sense.

Then why not mention that?

Is there some character limit in the changelog comment section that I
don't know about?  :)

Please, be much more descriptive so we have a chance to know what is
going on.

> The first message is no longer required since we now set some default
> value (25% of RAM) instead of zero. So, if user doesn't provide any
> disksize value, we use the default.
> 
> The second message really doesn't belong in a kernel driver. That's more
> of a documentation or user commonsense thing.  If a user really thinks
> that the data to be written is going to be highly compressible, setting
> zram to such large value makes some sense and there is little point in
> throwing out this big warning in system logs.

Again, put this in the changelog...

greg k-h
