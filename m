Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab0I1Wxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 18:53:53 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:53785 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab0I1Wxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 18:53:51 -0400
X-Originating-Ip: 216.16.235.2
Date: Tue, 28 Sep 2010 18:52:02 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: Richard Weinberger <richard@nod.at>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net, janjaap@bos.nl,
        geert@linux-m68k.org, jaxboe@fusionio.com, martin.petersen@oracle.com,
        adobriyan@gmail.com, syzop@vulnscan.org
Subject: Re: [PATCH 1/1] um: ubd: Fix data corruption
Message-ID: <20100928225202.GA30352@foursquare.net>
References: <1285710456-4435-1-git-send-email-richard@nod.at> <20100928150000.f007f43e.akpm@linux-foundation.org> <201009290013.11332.richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009290013.11332.richard@nod.at>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 12:13:10AM +0200, Richard Weinberger wrote:
> Am Mittwoch 29 September 2010, 00:00:00 schrieb Andrew Morton:
> > This is a workaround, I think?  Do we know what the actual bug is?
> > From the comment it appears to be a regression?
> 
> Yes, it is a workaround.
> For more details please have a look at this post:
> http://lkml.org/lkml/2010/9/28/245

I'm going to run some tests to see how this works on my end, but in
reading old threads, I found this response from Bram Matthys
that casts some doubt on an older version of this patch.

	http://marc.info/?l=user-mode-linux-user&m=126883932731656&w=2

I've added him to the CC.

- Chris

