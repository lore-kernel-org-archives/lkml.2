Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab1CJRUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 12:20:07 -0500
Received: from kroah.org ([198.145.64.141]:38847 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab1CJRUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 12:20:04 -0500
Date: Thu, 10 Mar 2011 09:19:40 -0800
From: Greg KH <greg@kroah.com>
To: Nikolai Kondrashov <spbnick@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110310171940.GA24972@kroah.com>
References: <20110209224006.GA11202@kroah.com>
 <AANLkTikrr6Gu_qoq73ASC95E0HQC1p6KzDPLxo=J_rva@mail.gmail.com>
 <20110225210334.GB16860@kroah.com>
 <4D6823DD.6040809@gmail.com>
 <20110225225055.GA5931@kroah.com>
 <4D787714.6060405@gmail.com>
 <20110310170143.GA24559@kroah.com>
 <AANLkTinyqJx76=nzepa9fe5VDzqiXRGCQ=E1SsKm2npE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinyqJx76=nzepa9fe5VDzqiXRGCQ=E1SsKm2npE@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 07:13:14PM +0200, Nikolai Kondrashov wrote:
> Hi Greg,
> 
> On Thu, Mar 10, 2011 at 7:01 PM, Greg KH <greg@kroah.com> wrote:
> > Ok, then I'm afraid that this driver will not support your laptop,
> > sorry.
> Oh, heck! I forgot I've upgraded my netbook to n230 (which is not
> supported as I see now) and left n210 to my wife.
> I'll test it on n210 and then report back to you.
> 
> Sorry for the noise.
> 
> BTW, I'm ready to test n230 support, if you implement it.

Can you provide me the output of:
	grep . /sys/class/dmi/id/*
so I can try to add support for this machine to the driver?

thanks,

greg k-h
