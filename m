Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161806Ab2CSQnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:43:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44868 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab2CSQna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:43:30 -0400
Date: Mon, 19 Mar 2012 09:43:25 -0700
From: Gerard Snitselaar <dev@snitselaar.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, fmhess@users.sourceforge.net,
        abbotti@mev.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: comedi: resolve section mismatch in s626
Message-ID: <20120319164325.GA31833@perelman.Home>
Reply-To: Gerard Snitselaar <dev@snitselaar.org>
References: <1332123921-14347-1-git-send-email-dev@snitselaar.org>
 <20120319030925.GB22956@perelman.Home>
 <20120319163103.GC3694@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319163103.GC3694@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 09:31:03AM -0700, Greg KH wrote:
> 
> Ick, why is this loop even needed?  We are only here if the pci device
> is present in the system so this shouldn't be needed at all, right?
> 
> Or is this a bit more complex than I am making it out to be?
> 
> greg k-h

Most likely not. I will take a look at some of the other drivers in
comedi and see how the attach code looks there. I believe the code
section in hpdi_attach() was written by the same person. Unfortunately
I don't have a device to actually play around and see what changes are
doing.

