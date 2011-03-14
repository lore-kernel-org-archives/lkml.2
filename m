Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab1CNDX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 23:23:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:46302 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab1CNDX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 23:23:58 -0400
Date: Sun, 13 Mar 2011 20:24:37 -0700
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 11/21] Staging: hv: Make vmbus driver a platform pci
 driver
Message-ID: <20110314032437.GA18645@suse.de>
References: <1299794912-1233-1-git-send-email-kys@microsoft.com>
 <20110310222034.GA19323@suse.de>
 <6E21E5352C11B742B20C142EB499E048018AA3@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20110310223256.GA8669@suse.de>
 <6E21E5352C11B742B20C142EB499E048018F4D@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048018F4D@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 12, 2011 at 11:23:05PM +0000, KY Srinivasan wrote:
> Greg, I have redone this patch as well as [PATCH 12/21]. Do you want
> me send you just these two patches or the entire series including
> these two.

Just resend those two patches if that is easier.

> Also, does this patch-set address all of architectural issues you had
> noted earlier in the vmbus core. Please let us know what else needs to
> be done to exit staging as far as the vmbus driver is concerned. I
> want get a head start before the new week begins! Also, we have
> patches ready for all DPRINT cleanup. Hank is holding them off until
> we finish addressing the architectural issues first.

I do not know if this addresses everything, sorry, I have not had the
time to review all of them yet.  Give me a few days at the least to go
over them and apply them before I will be able to tell you this.

Also note that there shouldn't be anything holding back the DPRINT
stuff, why wait?  If they apply on top of yours that should be fine,
right?

thanks,

greg k-h
