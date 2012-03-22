Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014Ab2CVV0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:26:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34234 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758358Ab2CVV0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:26:46 -0400
X-Sasl-enc: 0QH4HtmN9huK943xbQHChCoKlZ5tFZshqQOYu1/EE8Ga 1332451605
Date: Thu, 22 Mar 2012 14:26:44 -0700
From: Greg KH <greg@kroah.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regression introduced in v3.2.12 stable
Message-ID: <20120322212644.GA30888@kroah.com>
References: <4F6B7A37.3020300@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6B7A37.3020300@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 03:15:03PM -0400, Joseph Salisbury wrote:
> I figured I'd send a heads up regarding a possible regression in v3.2.12
> stable.  The issue prevents systems from booting.
> 
> There have been a few bugs[0] reported against the Ubuntu kernel, which
> was recently rebased to 3.2.12.  We're in the process of bisecting now
> and will post an update..

What specifically happens here when the system does not boot?  Any error
message?  Are you sure this isn't the known pci express issue showing up
here?

Can you run 'git bisect' to trace it down to a specific patch please?

thanks,

greg k-h
