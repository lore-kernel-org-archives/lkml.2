Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab1DKTJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 15:09:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258Ab1DKTJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 15:09:44 -0400
Date: Mon, 11 Apr 2011 12:07:08 -0700
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: Hyper-V vmbus driver
Message-ID: <20110411190708.GA21355@suse.de>
References: <6E21E5352C11B742B20C142EB499E0481C8D35@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481C8D35@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 06:46:24PM +0000, KY Srinivasan wrote:
> Greg,
> 
>  
> 
> Recently, you applied a patch-set from me that cleaned a bunch of architectural
> issues  in the vmbus driver.
> 
> With that patch-set, I think I have addressed all architectural issues that I
> am aware of.
> 
> I was wondering if you would have the time to let me know what else would have
> to be addressed
> 
> in the vmbus driver, before it could be considered ready for exiting staging.
> As always your help is
> 
> greatly appreciated.

Hm, interesting word wrapping there, might I consider a "real" email
client one of these days?  :)

Anyway, yes, I discussed this with Hank last week at the LF Collab
summit.  I'll look at the vmbus code later this week when I catch up on
all of my other work (stable, usb, tty, staging, etc.) that has piled up
during my 2 week absence, and get back to you with what I feel is still
needed to be done, if anything.

thanks,

greg k-h
