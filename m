Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018Ab2ESCOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 22:14:24 -0400
Received: from linux-sh.org ([111.68.239.195]:48857 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab2ESCOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 22:14:22 -0400
Date: Sat, 19 May 2012 11:13:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, linus.walleij@stericsson.com, arnd@arndb.de,
        linux-sh@vger.kernel.org, horms@verge.net.au, olof@lixom.net
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver V2
Message-ID: <20120519021354.GI24355@linux-sh.org>
References: <20120515154333.6659.66479.sendpatchset@w520>
 <20120516072927.GN7988@linux-sh.org>
 <20120518225747.893F33E07C8@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518225747.893F33E07C8@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 04:57:47PM -0600, Grant Likely wrote:
> On Wed, 16 May 2012 16:29:28 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> > After which point you can iterate and dispose of the virq mappings with
> > irq_dispose_mapping(). The lack of irq domain teardown functionality does
> > need to be addressed though.
> 
> Yes, that falls firmly in the "that's a bug" category.  I need to get
> some time to fix it if someone doesn't beat me to it.
> 
I've got some code done for it already, along with a batch of other
changes. I'll have the series out for you shortly as soon as I'm done
with some additional testing.
