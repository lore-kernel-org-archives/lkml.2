Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab0JFBvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:51:48 -0400
Received: from kroah.org ([198.145.64.141]:43674 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757610Ab0JFBvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:51:39 -0400
Date: Tue, 5 Oct 2010 18:52:04 -0700
From: Greg KH <greg@kroah.com>
To: T Dent <tdent48227@gmail.com>
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/28] Staging: comedi: Fixed numerous file so that it
	had little or no complaints from checkpatch.pl
Message-ID: <20101006015204.GA22411@kroah.com>
References: <AANLkTi=GrHjrZaKdX8DiDf2nT-SByifSxn2sW_0NQWd_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=GrHjrZaKdX8DiDf2nT-SByifSxn2sW_0NQWd_@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 09:15:16PM -0400, T Dent wrote:
> I fixed a lot of coding style errors, that checkpatch.pl had found. I
> didn't do some files in the drivers/ subdirectory because the warnings
> that were being produce was spacing errors. So spacing wasn't that
> serious ,so I skim and look for if it was anymore wranings or errors.
> There was none so I skip the rest.
> 
> This is my last full scale checkpatch.pl patch series, as I'm going to
> try to contribute more interesting things to the Linux kernel. :)

As mentioned in the response to 01/28, these are all just fine as-is and
don't need to be changed, sorry.  Go bug the checkpatch author to remove
this from the tool.

sorry,

greg k-h
