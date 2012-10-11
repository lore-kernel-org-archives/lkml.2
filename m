Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab2JKLbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 07:31:14 -0400
Received: from 1wt.eu ([62.212.114.60]:32790 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757658Ab2JKLbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 07:31:12 -0400
Date: Thu, 11 Oct 2012 13:31:06 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>
Cc: Romain Francoise <romain@orebokech.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, hpa@zytor.com
Subject: Re: Linux 2.6.32.60
Message-ID: <20121011113106.GR8938@1wt.eu>
References: <20121009094453.GA4289@1wt.eu> <87y5jeqv6b.fsf@silenus.orebokech.com> <20121011062916.GG8938@1wt.eu> <20121011105804.GB28546@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011105804.GB28546@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 07:58:04PM +0900, Greg KH wrote:
> On Thu, Oct 11, 2012 at 08:29:16AM +0200, Willy Tarreau wrote:
> > If you think these patches constitute a regression, I can revert them.
> > However I'd like convincing arguments since they're here to help address
> > a real issue.
> 
> If I missed these when doing the random number generation backport for
> 3.0, and I should add them there as well, please let me know.

At least I think they should not be in 2.6.32 without being in 3.0.
Probably that Peter's opinion will help us decide whether they should
go into 3.0 or 2.6.32 should revert them.

Regards,
Willy

