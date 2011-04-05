Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab1DEPKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:10:11 -0400
Received: from kroah.org ([198.145.64.141]:58445 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab1DEPKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:10:08 -0400
Date: Tue, 5 Apr 2011 08:10:46 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 00/22] Staging: hv: Cleanup-storage-drivers-phase-III
Message-ID: <20110405151046.GF28289@kroah.com>
References: <1301331615-26226-1-git-send-email-kys@microsoft.com>
 <20110405045904.GA4635@kroah.com>
 <6E21E5352C11B742B20C142EB499E04802BFE3@TK5EX14MBXC122.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E04802BFE3@TK5EX14MBXC122.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top


On Tue, Apr 05, 2011 at 01:58:37PM +0000, KY Srinivasan wrote:
> Sorry for the confusion Greg. I reworked some patches in Phase-II
> cleanup and I was meaning to resend them before you began applying the
> patches, That is the reason for the problem you are encountering.

Huh?  I applied them in the order you sent them to me, how would that
cause a patch to fail to apply properly?

> I
> just resent the Phase II series. If you can back out the phase II that
> you have applied and apply the ones I resent, everything should apply
> cleanly. Once again, I sorry for creating additional work for you.

I can't back out anything, sorry.  I'll drop any pending patches you
have sent me now.  Please resync with my staging git tree and resend
them to properly apply and work.

thanks,

greg k-h
