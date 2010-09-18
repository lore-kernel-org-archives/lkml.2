Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0IRLV5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 07:21:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51901 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab0IRLVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 07:21:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GbcqaLzeNsIEfChCFPAvPW6i/grOUgwHNAqQOIzslHGDwBv+9TSv8PCD4+cIptpVc5
         R6Twove+1SYyoMhxGG0DWFIXwMzwl9xvSMq8aaQLLnbY5auRcdB0D3aOm5ZV+Ka6a1A/
         sbQdhJTKncbZnGiRed/kC5N9I2XL/cuFU0a98=
Date: Sat, 18 Sep 2010 15:21:50 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: kernel-janitors@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Luotao Fu <l.fu@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: stmpe: fix error path
Message-ID: <20100918112150.GA3351@albatros>
References: <1284317840-5131-1-git-send-email-segooon@gmail.com>
 <20100913193728.GA14993@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913193728.GA14993@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 21:37 +0200, Wolfram Sang wrote:
> On Sun, Sep 12, 2010 at 10:57:19PM +0400, Vasiliy Kulikov wrote:
> > Free allocated memory.  Call stmpe_disable() if it was enabled.
> > 
> > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> > ---
> >  Compile tested.
> >  Maybe It needs better error path.
> 
> What do you mean here? Looks good to me so far.

Forget it, I was wrong ;)


-- 
Vasiliy
