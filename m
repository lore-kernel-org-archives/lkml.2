Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab1ELFaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 01:30:11 -0400
Received: from kroah.org ([198.145.64.141]:37280 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab1ELFaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 01:30:09 -0400
Date: Wed, 11 May 2011 22:31:09 -0700
From: Greg KH <greg@kroah.com>
To: matt mooney <mfmooney@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 00/12] staging: usbip: miscellaneous code cleanup
Message-ID: <20110512053109.GA26926@kroah.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
 <20110511211401.GC4893@kroah.com>
 <BANLkTikjf9ZAthr3jTUkoUKGJt2UGS73Cg@mail.gmail.com>
 <20110511231843.GC7362@kroah.com>
 <BANLkTim_WZdmE31qjChg8u0M8RKzez3fqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim_WZdmE31qjChg8u0M8RKzez3fqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 08:24:12PM -0700, matt mooney wrote:
> > We add it to drivers/staging/usbip/userspace/ and build it like the perf
> > code is built.
> 
> Okay, I will add the code as is to userspace/ except for the module
> name changes of course. Now I am suppose to add this to
> scripts/packages/Makefile or is there another way for staging?

I really don't know as I haven't looked at that part of the build system
in years.  If you have problems, I will be glad to help out, but give it
a try first :)

thanks,

greg k-h
