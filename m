Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab2LAAwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:52:30 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45925 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2LAAw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:52:29 -0500
Date: Fri, 30 Nov 2012 16:52:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Anthony Foiani <tkil@scrye.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: Enumerate the guidelines for stable
 patches.
Message-ID: <20121201005225.GA19767@kroah.com>
References: <gr4na1u02.fsf@dworkin.scrye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gr4na1u02.fsf@dworkin.scrye.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 05:44:13PM -0700, Anthony Foiani wrote:
> 
> From: Anthony Foiani <anthony.foiani@gmail.com>
> 
> Having recently received a formletter rejection on a stable patch, I
> found it difficult to determine exactly which guideline I had missed.
> 
> Numbering the guidelines will allow the stable maintainer to quickly
> and easily indicate which guidelines have not been followed.
> 
> The actual changes are only the addition of clause numbering, and the
> wishful thinking added to S15.

Is this really needed?  For the large majority of the stable patches,
specifically enumerating this isn't a big deal, it's a tiny patch, and
if you think I'll remember to tell you which specific clause you didn't
follow, then you think I have more spare time than I really do.

Sorry, but no, I don't think this patch is ok, especially that S15
clause, nice try :)

greg k-h
