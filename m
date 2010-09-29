Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab0I2Dc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 23:32:28 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:55510 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab0I2Dc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 23:32:27 -0400
X-Originating-Ip: 216.16.235.2
Date: Tue, 28 Sep 2010 23:30:38 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: Richard Weinberger <richard@nod.at>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net, janjaap@bos.nl,
        geert@linux-m68k.org, jaxboe@fusionio.com, martin.petersen@oracle.com,
        adobriyan@gmail.com
Subject: Re: [PATCH 1/1] um: ubd: Fix data corruption
Message-ID: <20100929033038.GA7668@foursquare.net>
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

I am so far unable to reproduce the corruption with this workaround patch.
So it looks like we have at least one fix.

Thank you very much to everyone who worked on this.

- Chris

