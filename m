Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab1CJRGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 12:06:01 -0500
Received: from kroah.org ([198.145.64.141]:55215 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab1CJRF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 12:05:59 -0500
Date: Thu, 10 Mar 2011 09:01:43 -0800
From: Greg KH <greg@kroah.com>
To: Nikolai Kondrashov <spbnick@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110310170143.GA24559@kroah.com>
References: <20110209224006.GA11202@kroah.com>
 <AANLkTikrr6Gu_qoq73ASC95E0HQC1p6KzDPLxo=J_rva@mail.gmail.com>
 <20110225210334.GB16860@kroah.com>
 <4D6823DD.6040809@gmail.com>
 <20110225225055.GA5931@kroah.com>
 <4D787714.6060405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D787714.6060405@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 09:00:36AM +0200, Nikolai Kondrashov wrote:
> Hi Greg,
> 
> On 02/26/2011 12:50 AM, Greg KH wrote:
> >On Sat, Feb 26, 2011 at 12:49:17AM +0300, Nikolai Kondrashov wrote:
> >>On 02/26/2011 12:03 AM, Greg KH wrote:
> >>>This should work, as we support the N150/N210/N220 versions.
> >>>
> >>>Can you provide the output of:
> >>>	grep ./sys/class/dmi/id/*
> >>>
> >>>so I can verify this?
> >>Sure. Please find it attached. It is taken on a stock Debian kernel, without
> >>your patch.
> >>
> >>Could I have configured the kernel incorrectly?
> >
> >Maybe, that's odd.
> >
> >Care to try the version of the patch below to see if that works better
> >for you or not?
> Thank you. The result is the same: ENODEV without "force" and "This computer
> doesn't support SABI" and EINVAL with "force".

Ok, then I'm afraid that this driver will not support your laptop,
sorry.

greg k-h
