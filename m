Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab1BVJ2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 04:28:42 -0500
Received: from ist.d-labs.de ([213.239.218.44]:53654 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab1BVJ2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 04:28:40 -0500
Date: Tue, 22 Feb 2011 10:28:20 +0100
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        jiaweiwei.xiyou@gmail.com, linux-kernel@vger.kernel.org,
        greg@kroah.com, rdunlap@xenotime.net, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH]move double quotation marks so that keep MAINTAINERS
 consistent
Message-ID: <20110222102820.56a49c89@schatten.dmk.lab>
In-Reply-To: <1298152790.7179.27.camel@Joe-Laptop>
References: <20110210025133.GA3285@gmail.com>
	<20110209190631.f29419ef.akpm@linux-foundation.org>
	<20110209.191752.226762899.davem@davemloft.net>
	<20110219164839.GA20047@ucw.cz>
	<1298152790.7179.27.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Feb 2011 13:59:50 -0800
Joe Perches <joe@perches.com> wrote:

> On Sat, 2011-02-19 at 17:48 +0100, Pavel Machek wrote:
> > On Wed 2011-02-09 19:17:52, David Miller wrote:
> > > From: Andrew Morton <akpm@linux-foundation.org>
> > > > I suspect that some mail clients will explode if you provide them with
> > > > an unquoted string containing periods.  That would make copy-n-paste
> > > > rather a hassle.
> > > It's not clients, it's servers.
> > > SMTP rules state that characters such as "." cannot appear
> > > unquoted in email headers.
> > > vger.kernel.org rejects mail when this violation occurs.
> > Ok, but should not MUA do this quotation? Quick test shows that mutt does... 
> 
> My recollection is that the get_maintainer script
> cannot parse M: lines with multiple entries with
> periods without the quotes.
> 
> M:	First I. Last <fil@foo.bar>, Last.I.First <lif@foo.bar>
> 
> fails and
> 
> M:	"First I. Last" <fil@foo.bar>, "Last.I.First" <lif@foo.bar>
> 
> succeeds.
> 
> You are welcome to improve the parsing in that routine.
> 

There are perl modules providing full rfc parsing of email addresses
(with all those weird cases nobody uses) ... but i doubt it's urgent,
especially as we can more or less control the input to get_maintainer.pl
by controlling the MAINTAINER file and the git version history ...

