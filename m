Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab2KVSlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:41:16 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57009 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab2KVSlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:41:15 -0500
Date: Wed, 21 Nov 2012 13:31:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux list <linux-kernel@vger.kernel.org>, tom.leiming@gmail.com
Subject: Re: =?utf-8?Q?drivers=2Fusb=2Fusb-skeleton?=
 =?utf-8?B?LmM6MTE3OjM6IGVycm9yOiBsYWJlbCDigJhvdXRfZXJy?= =?utf-8?B?4oCZ?=
 used but not define
Message-ID: <20121121213113.GA30140@kroah.com>
References: <CACnwZYdSW5=MLBrOC_cD7b3AB_PcQeyjR=JPJnfPCzJapZbGEw@mail.gmail.com>
 <20121118034117.GA2604@kroah.com>
 <CACnwZYcbaTbRX7_tv5x1yPNbPwPkp4nT=upBCatYEgp0YESYYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACnwZYcbaTbRX7_tv5x1yPNbPwPkp4nT=upBCatYEgp0YESYYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 12:06:31PM -0200, Thiago Farina wrote:
> On Sun, Nov 18, 2012 at 1:41 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >> If not, what would be the right fix?
> >
> > Properly define out_err.
> >
> > I thought this all got fixed up recently, what kernel version are you
> > looking at?
> >
> That might explain why I'm seeing this.
> 
> Because I'm building the kernel I checked out from
> git://github.com/torvalds/linux.git, currently at commit f4a75d2e
> (Linux 3.7-rc6).

Yes, this fixed up in linux-next (just checked it), and will be resolved
in 3.8-rc1.

sorry about that.

greg k-h
