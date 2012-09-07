Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab2IGBPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 21:15:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55052 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab2IGBPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 21:15:50 -0400
Date: Thu, 6 Sep 2012 18:15:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.4.10 i915 [GM45] regression
Message-ID: <20120907011542.GA26688@kroah.com>
References: <2372445.fuIXicT4H0@tux200s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2372445.fuIXicT4H0@tux200s>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 02:27:12AM +0200, Andreas Sturmlechner wrote:
> Hello,
> 
> please revert commit 0d8957c8a90bbb5d34fab9a304459448a5131e06 - for some 
> reason it breaks boot-up (screen stays blank) on my GM45 hardware despite >= 
> 3.5 being fine.
> 
> See bug 54575 on freedesktop.org for a full description: 
> https://bugs.freedesktop.org/show_bug.cgi?id=54575
> 
> No idea how far-spread or not this might be since I couldn't find any other 
> reports of that kind.

Can you cc: this to the people who wrote that patch?  That might help in
figuring out what is wrong here...

thanks,

greg k-h
