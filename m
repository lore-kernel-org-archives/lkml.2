Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab2F2DgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 23:36:04 -0400
Received: from gherkin.frus.com ([192.158.254.49]:39601 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab2F2DgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 23:36:01 -0400
Date: Thu, 28 Jun 2012 22:36:00 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.5-rcX: USB support without udev?
Message-ID: <20120629033600.GA3591@gherkin.frus.com>
References: <20120628131651.GA14492@gherkin.frus.com> <CACVXFVNLVwNLDbpxdOMT_RCzqU=gx8O-2oZ8XQ8K87HwUBVWDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNLVwNLDbpxdOMT_RCzqU=gx8O-2oZ8XQ8K87HwUBVWDA@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 09:39:45PM +0800, Ming Lei wrote:
> On Thu, Jun 28, 2012 at 9:16 PM, Bob Tracy <rct@gherkin.frus.com> wrote:
> > With the removal of the deprecated usbfs feature in the 3.5 release
> > candidates, is there a way of getting USB devices working on a non-
> > embedded Linux system without udev (static "/dev")?
> 
> Please try to enable below options:
> 
> CONFIG_DEVTMPFS=y
> CONFIG_DEVTMPFS_MOUNT=y
> 
> and you need not the static dev nodes with devtmpfs.

It was worth a try, but it didn't help in my situation.  This system
also has an updated Kubuntu partition available to boot, so I'll try
that and take lots of notes as far as what devices "udev" creates.
That approach was good enough to get my sound card working, which would
otherwise have required "udev".

Thanks.
--Bob
