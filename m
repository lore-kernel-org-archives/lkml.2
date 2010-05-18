Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754Ab0ERONg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:13:36 -0400
Received: from nessie.weebeastie.net ([220.233.7.36]:50250 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755760Ab0ERONd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 10:13:33 -0400
Date: Wed, 19 May 2010 00:13:15 +1000
From: CaT <cat@zip.com.au>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, bzolnier@gmail.com,
       stable@kernel.org, ben@decadent.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34 (rt2860 regression)
Message-ID: <20100518141315.GA2657@zip.com.au>
References: <alpine.LFD.2.00.1005161430100.4195@i5.linux-foundation.org> <20100518114426.GY2657@zip.com.au> <20100518125539.GA23181@kroah.com> <20100518131706.GZ2657@zip.com.au> <20100518133336.GA23591@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518133336.GA23591@kroah.com>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 06:33:36AM -0700, Greg KH wrote:
> Just update the linux-firmware package and all will be working again.
> We've been moving the firmware out of the staging drivers for a while
> now, as they don't belong in the kernel tree.

Curses. Ok. Is there any chance of being able to include these in the
vmlinuz file (for the sake of tidyness) or are, after 12 years or so,
my monolithic days over?

-- 
  "A search of his car uncovered pornography, a homemade sex aid, women's 
  stockings and a Jack Russell terrier."
    - http://www.news.com.au/story/0%2C27574%2C24675808-421%2C00.html
