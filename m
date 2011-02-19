Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab1BSV7x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 16:59:53 -0500
Received: from mail.perches.com ([173.55.12.10]:3782 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab1BSV7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 16:59:52 -0500
Subject: Re: [PATCH]move double quotation marks so that keep MAINTAINERS
 consistent
From: Joe Perches <joe@perches.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        jiaweiwei.xiyou@gmail.com, linux-kernel@vger.kernel.org,
        greg@kroah.com, rdunlap@xenotime.net
In-Reply-To: <20110219164839.GA20047@ucw.cz>
References: <20110210025133.GA3285@gmail.com>
	 <20110209190631.f29419ef.akpm@linux-foundation.org>
	 <20110209.191752.226762899.davem@davemloft.net>
	 <20110219164839.GA20047@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Feb 2011 13:59:50 -0800
Message-ID: <1298152790.7179.27.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-02-19 at 17:48 +0100, Pavel Machek wrote:
> On Wed 2011-02-09 19:17:52, David Miller wrote:
> > From: Andrew Morton <akpm@linux-foundation.org>
> > > I suspect that some mail clients will explode if you provide them with
> > > an unquoted string containing periods.  That would make copy-n-paste
> > > rather a hassle.
> > It's not clients, it's servers.
> > SMTP rules state that characters such as "." cannot appear
> > unquoted in email headers.
> > vger.kernel.org rejects mail when this violation occurs.
> Ok, but should not MUA do this quotation? Quick test shows that mutt does... 

My recollection is that the get_maintainer script
cannot parse M: lines with multiple entries with
periods without the quotes.

M:	First I. Last <fil@foo.bar>, Last.I.First <lif@foo.bar>

fails and

M:	"First I. Last" <fil@foo.bar>, "Last.I.First" <lif@foo.bar>

succeeds.

You are welcome to improve the parsing in that routine.

