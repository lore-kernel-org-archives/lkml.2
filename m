Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0IWTSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:18:36 -0400
Received: from kroah.org ([198.145.64.141]:51321 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197Ab0IWTSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:18:33 -0400
Date: Thu, 23 Sep 2010 11:43:29 -0700
From: Greg KH <greg@kroah.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Islam Amer <pharon@gmail.com>, stable@kernel.org,
        akpm@linux-foundation.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [stable] Dell Studio 1555 eject key does not work ( small
 patch to fix included )
Message-ID: <20100923184329.GV23040@kroah.com>
References: <AANLkTinG3jv6o8T00mDTEP5uxf4tKqOwSPEDIUcv4kVG@mail.gmail.com>
 <20100906191204.GL2684@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100906191204.GL2684@bombadil.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 03:12:04PM -0400, Kyle McMartin wrote:
> On Thu, Jun 03, 2010 at 01:14:09AM +0400, Islam Amer wrote:
> > I had submitted this as
> > https://bugzilla.kernel.org/show_bug.cgi?id=16075 but repeating the
> > information and patch
> > here as per Andrew Morton's suggestion.
> > 
> 
> Thanks for sending this fix in, Islam. Adding stable@ to the Cc.
> 
> Greg, could you apply this to the stable tree as well? Should apply a
> few releases back. We applied it to .34 and .35 in Fedora, at least.
> 
> The upstream commit id was d5164dbf1f651d1e955b158fb70a9c844cc91cd1.

Now queued up in the .35-stable tree.

thanks,

greg k-h
