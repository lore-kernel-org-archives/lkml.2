Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0KISYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:24:53 -0500
Received: from kroah.org ([198.145.64.141]:60263 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab0KISYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:24:51 -0500
Date: Tue, 9 Nov 2010 10:24:37 -0800
From: Greg KH <greg@kroah.com>
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
Message-ID: <20101109182437.GA13499@kroah.com>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
 <AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
 <20101106181202.GA6927@kroah.com>
 <39580686-A899-4689-BAAD-AF5546B34E49@mac.com>
 <AANLkTimVsUsrmTvsHqFiqJh1hhryMBemGyW+kYLKGgEu@mail.gmail.com>
 <20101107155757.GA13736@kroah.com>
 <6477C549-DB75-407C-9B9B-5869A3B8D2BD@mac.com>
 <DC5F0A5D-0107-4214-A4D7-6FDA166518BA@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DC5F0A5D-0107-4214-A4D7-6FDA166518BA@mac.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 10:10:56PM +0400, Elvis Dowson wrote:
> Hi,
> Is there an efficient way to locally store all LKML mailing list
> archives, so that I can efficiently filter on only the android patch
> review comments?

Yes, there are loads of tools that do this.  mairix is one that I like
to use to search email archives.

> I was thinking of looking at the review comments, incorporating some
> of the changes, get that reviewed after testing those changes with
> modified android low-level libraries (I'm guessing mostly
> android/bionic, but need to check this). 

If you have the rights to make the changes to the andoid userspace code,
great.  Otherwise you are not going to get very far.

good luck,

greg k-h
