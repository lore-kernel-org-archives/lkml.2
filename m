Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750821Ab1ITNEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:04:21 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45726 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696Ab1ITNER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:04:17 -0400
X-Sasl-enc: 7w7hMIONLlLVV3otq1lE3H5zLHPw6nl450V8p8ywWLmw 1316523856
Date: Tue, 20 Sep 2011 05:58:45 -0700
From: Greg KH <greg@kroah.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Greg KH <gregkh@suse.de>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, stable@kernel.org,
        Andiry Xu <andiry.xu@amd.com>, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [patch 2/3] USB: xhci: Set change bit when warm reset change is
 set.
Message-ID: <20110920125845.GB9820@kroah.com>
References: <20110919230833.469891151@clark.kroah.org>
 <4E78775F.9020501@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E78775F.9020501@ru.mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 03:22:07PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 20-09-2011 3:05, Greg KH wrote:
> 
>    From: line is missing?

Crap, me switching from git to quilt caused this to happen.  My
apologies Sarah.

greg k-h
