Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab1FJXRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 19:17:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758176Ab1FJXRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 19:17:36 -0400
Date: Fri, 10 Jun 2011 16:17:21 -0700
From: Greg KH <gregkh@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110610231721.GA18608@suse.de>
References: <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com>
 <20110607014127.GA8450@srcf.ucam.org>
 <4DED8752.5070005@kernel.org>
 <4DEDEA73.7010900@gmail.com>
 <20110610164706.GB25774@srcf.ucam.org>
 <4DF259B2.9070403@gmail.com>
 <20110610175429.GA28500@srcf.ucam.org>
 <4DF29E7E.50908@gmail.com>
 <4DF2A17E.7000103@kernel.org>
 <20110610230359.GA2084@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110610230359.GA2084@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 12:03:59AM +0100, Matthew Garrett wrote:
> On Fri, Jun 10, 2011 at 03:58:06PM -0700, Yinghai Lu wrote:
> 
> > the problem is : overlapping between kernel code with boot services code.
> 
> SHouldn't checking against the iomem resource map avoid that?
> 
> > now e820 table that is passed from bootloader do not include boot services code range. and also current boot/head_64.S will not
> > try to find usable range for decompressed kernel ( too early )...
> > 
> > So solution will be:
> > 1. revert Matthew Garrett's patch, because it breaking unknown good platform.
> 
> That's acceptable if we can't find a better solution.

If no one objects, I'd like to revert the EFI patch that went into
2.6.39.1 that is causing people problems so as to give everyone some
time to get 3.0 working properly on these boxes.

thanks,

greg k-h
