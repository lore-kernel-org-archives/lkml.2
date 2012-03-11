Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab2CKNCq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 09:02:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38844 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2CKNCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 09:02:43 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [patch] spi: release lock on error path in spi_pump_messages()
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: wharms@bfs.de, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20120311062059.GB3337@mwanda>
References: <20120310085729.GB4647@elgon.mountain> <4F5B2113.3060103@bfs.de> <20120311024307.AA5E33E0950@localhost> <20120311062059.GB3337@mwanda>
Date: Sun, 11 Mar 2012 07:02:40 -0600
Message-Id: <20120311130240.2DB083E0892@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2012 09:20:59 +0300, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sat, Mar 10, 2012 at 07:43:07PM -0700, Grant Likely wrote:
> > On Sat, 10 Mar 2012 10:38:27 +0100, walter harms <wharms@bfs.de> wrote:
> > > hi Dan,
> > > do you want to protect dev_err() by a spn_lock ?
> > 
> > Applied, after moving unlock above the dev_err.
> > 
> 
> Thanks.
> 
> I was going to resend this with Walter's change btw.  I wasn't going
> to ignore his review comments.

I assumed you would.  It was just simpler for me to pick it up with the
trivial change.

g.

