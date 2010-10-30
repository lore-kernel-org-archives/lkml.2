Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167Ab0J3UVm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 16:21:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:41945 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab0J3UVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 16:21:41 -0400
Date: Sat, 30 Oct 2010 22:21:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VIA Chrome integrated camera controller driver includes
 headers multiple times
In-Reply-To: <20101030084813.3581ea7e@bike.lwn.net>
Message-ID: <alpine.LNX.2.00.1010302220580.6879@pobox.suse.cz>
References: <alpine.LNX.2.00.1010301527580.7979@swampdragon.chaosbits.net> <20101030084813.3581ea7e@bike.lwn.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Oct 2010, Jonathan Corbet wrote:

> > The VIA Chrome integrated camera controller driver includes both 
> > 'linux/pci.h' and 'linux/device.h' twice. This gets rid of the duplicates.
> 
> Well, you see...I have teenage children.  So I've gotten very much used
> to the idea that you have to ask for anything at *least* twice have any
> chance of it actually happening.  Beyond that, the VIA controller has
> certain adolescent behavior patterns of its own...watch out when it's
> in a bad mood...so I just kind of fell into the habit of insisting.

It's always good to know the background of the bug. Do you want this to be 
included in the changelog? :)

> Seriously, though, I'm not sure how that happened.   Obviously:
> 
> 	Acked-by: Jonathan Corbet <corbet@lwn.net>

Applied. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
