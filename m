Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab2IETTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:19:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34123 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab2IETTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:19:32 -0400
Date: Wed, 5 Sep 2012 12:16:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Chanwoo Choi <cw00.choi@samsung.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH -next] extcon: extcon-arizona depends on INPUT
Message-ID: <20120905191657.GA5842@kroah.com>
References: <20120824172820.ee0f412d2944b08789414207@canb.auug.org.au>
 <5037B41C.6040703@xenotime.net>
 <503AB70E.2000407@samsung.com>
 <504693E4.8050808@xenotime.net>
 <20120905032802.GB5076@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905032802.GB5076@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 11:28:03AM +0800, Mark Brown wrote:
> On Tue, Sep 04, 2012 at 04:51:00PM -0700, Randy Dunlap wrote:
> 
> > This build error still happens in linux-next of 20120904.
> 
> > Can we get the patch merged for linux-next?
> 
> Greg's the one managing extcon in -next.

Yeah, can someone forward this to me so I can apply it?  I can't seem to
find it anywhere...

greg k-h
