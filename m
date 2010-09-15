Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab0IOD2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 23:28:47 -0400
Received: from mail.perches.com ([173.55.12.10]:2036 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab0IOD2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 23:28:46 -0400
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
From: Joe Perches <joe@perches.com>
To: Florian Mickler <florian@mickler.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Christoph Hellwig <hch@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
In-Reply-To: <20100914194646.52d4bf96@schatten.dmk.lab>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	 <1284111767.1783.35.camel@Joe-Laptop>
	 <20100911001350.GA11478@infradead.org>
	 <1284165074.1783.213.camel@Joe-Laptop>
	 <20100911004550.GA30584@infradead.org>
	 <20100911112855.6ee6e929@schatten.dmk.lab>
	 <m1hbhucdv5.fsf@fess.ebiederm.org> <1284364665.22185.116.camel@Joe-Laptop>
	 <20100913105434.62b150f7@schatten.dmk.lab>
	 <m1lj749ra2.fsf@fess.ebiederm.org>
	 <20100914194646.52d4bf96@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 20:28:44 -0700
Message-ID: <1284521324.26719.146.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-14 at 19:46 +0200, Florian Mickler wrote:
> On Tue, 14 Sep 2010 10:19:33 -0700
> ebiederm@xmission.com (Eric W. Biederman) wrote:
> > Florian Mickler <florian@mickler.org> writes:
> >
> 
> 
> 
> > What is needed is something other than output that is a list of
> > email addresses.
> > 
> > email address foo had x% of non-author signed off bys
> > email address foo had y% of author signed off bys
> > email address foo had y% of author commits.
> > email address foo came from the Maintainers file.
> 
> Currently get_maintainer.pl only does signed-off-by counting, it doesn't
> take authorship in account, IIRC. That is a good point. It's
> information that is easily available. 
> 
> > 
> > Additionally for email addresses that hit less often a list
> > of patch subject titles, and truncated sha1 patch ids.  So
> > with luck you can tell at a glance the person is of interest
> > and if not you can look at their commits quickly and see.
> 
> An interactive mode in git shortlog form of the last year should be
> possible, i guess. 
> 
> I wonder, if git send-email --cc-cmd allows for directing input towards
> get_maintainer.pl. That would be awesome.

Yes it does.  You could use any script or direct command
with arguments you like.

I sent you privately a script that does that last week.


