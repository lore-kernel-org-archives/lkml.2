Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab0ERPIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:08:34 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:60917 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757563Ab0ERPId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:08:33 -0400
Date: Tue, 18 May 2010 11:06:49 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: CaT <cat@zip.com.au>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       bzolnier@gmail.com, stable@kernel.org, ben@decadent.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34 (rt2860 regression)
Message-ID: <20100518150649.GA28567@elliptictech.com>
Mail-Followup-To: CaT <cat@zip.com.au>, Greg KH <greg@kroah.com>,
	Linus Torvalds <torvalds@linux-foundation.org>, bzolnier@gmail.com,
	stable@kernel.org, ben@decadent.org.uk,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.1005161430100.4195@i5.linux-foundation.org>
 <20100518114426.GY2657@zip.com.au>
 <20100518125539.GA23181@kroah.com>
 <20100518131706.GZ2657@zip.com.au>
 <20100518133336.GA23591@kroah.com>
 <20100518141315.GA2657@zip.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518141315.GA2657@zip.com.au>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 00:13 Wed 19 May     , CaT wrote:
> On Tue, May 18, 2010 at 06:33:36AM -0700, Greg KH wrote:
> > Just update the linux-firmware package and all will be working again.
> > We've been moving the firmware out of the staging drivers for a while
> > now, as they don't belong in the kernel tree.
> 
> Curses. Ok. Is there any chance of being able to include these in the
> vmlinuz file (for the sake of tidyness) or are, after 12 years or so,
> my monolithic days over?

Yes, you can do this: see the CONFIG_EXTRA_FIRMWARE option.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
