Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab1ITVCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:02:40 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58827 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743Ab1ITVCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:02:38 -0400
X-Sasl-enc: 7F4T7w+iK9+B7KpG42FGPkzpneJtnV5/3kDS7qdLwKD1 1316552557
Date: Tue, 20 Sep 2011 14:02:33 -0700
From: Greg KH <greg@kroah.com>
To: Henk de Groot <henk.de.groot@hetnet.nl>
Cc: Dave Kilroy <kilroyd@googlemail.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, pe1dnn@amsat.org
Subject: Re: [PATCH 3/3] staging: wlags49_h2: Declare support for WEXT 21
Message-ID: <20110920210233.GB9447@kroah.com>
References: <1316462896-17846-1-git-send-email-kilroyd@googlemail.com>
 <1316462896-17846-4-git-send-email-kilroyd@googlemail.com>
 <15411.1316463771@turing-police.cc.vt.edu>
 <4E77A9B1.1040107@gmail.com>
 <20110920195205.GA27739@kroah.com>
 <4E78F47B.7000906@hetnet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E78F47B.7000906@hetnet.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 10:15:55PM +0200, Henk de Groot wrote:
> Hello Greg,
> 
> Op 20-9-2011 21:52, Greg KH schreef:
> >I've applied the first 2 of these, if you want me to apply the third
> >one, please resend it after it's been tested by someone.
> >
> >thanks,
> >
> >greg k-h
> >
> 
> I have the patched driver running on the 2.6.38-11-generic #48
> Ubuntu 11.04 Natty Narwhal kernel, which, as far as I could
> determine, uses WEXT version 22. The patch didn't improve anything
> other than the code itself, but didn't break anything either. Tested
> with WEP accesspoint, WPA still not functional. The still appears to
> be stable.

So, should I apply this patch or not?

confused,

greg k-h
