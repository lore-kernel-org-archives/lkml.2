Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab2IJSGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:06:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33065 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751774Ab2IJSGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:06:52 -0400
X-Sasl-enc: 9C9fh6YP7tPQLQ1pj5vfphYrehJSMSzcFzokH427Bdor 1347300411
Date: Mon, 10 Sep 2012 11:04:13 -0700
From: Greg KH <greg@kroah.com>
To: DanielC <puff65537@bansheeslibrary.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.6rc5.linux-next 1/1] Force module
Message-ID: <20120910180413.GA31046@kroah.com>
References: <20120910170409.59b71819008bc527130d3987@canb.auug.org.au>
 <20120910173153.GA25033@kroah.com>
 <20120911014330.GA15327@elbert.example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911014330.GA15327@elbert.example.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 06:43:30PM -0700, DanielC wrote:
> Sorry about breaking the build, this should fix.

This doesn't make sense in a changelog entry.

> 
> Staging: silicom: Depend on module until monolithic build fixed

This needs to be in the Subject: line of the patch, don't make me edit
it by hand to add it in.

> 
> Signed-off-by: Daniel Cotey <puff65537@bansheeslibrary.com>

You forgot to add:
	Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
to this list, as he is the one that found the problem.

Care to fix this up and resend the patch so I can apply it without
needing to edit it at all?

thanks,

greg k-h
