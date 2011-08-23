Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab1HWWPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:15:24 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:36203 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755036Ab1HWWPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:15:16 -0400
X-Sasl-enc: FLrSag89wLeKaUlY/9j6rxenzwFJKdipauhokWroI7Fg 1314137716
Date: Tue, 23 Aug 2011 15:14:43 -0700
From: Greg KH <greg@kroah.com>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: martyn.welch@ge.com, gregkh@suse.de, cota@braap.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] [RESEND v2] VME Framework Fixes
Message-ID: <20110823221443.GC15721@kroah.com>
References: <1313145051-13397-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313145051-13397-1-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 12:30:46PM +0200, Manohar Vanga wrote:
> Hi Martyn,
> 
> This is the updated list of patches. I have removed the bus numbering
> patch as we can work on it further before adding it in. Some notes on
> the various patches below:
> 
>   staging: vme: make [alloc|free]_consistent bridge specific

I've applied the first 2 only.

Martyn, my vme patch queue is now empty, if I have missed anything I
should have applied, please resend it and let me know.

thanks,

greg k-h
