Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab1BTQAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 11:00:25 -0500
Received: from mail.perches.com ([173.55.12.10]:3803 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab1BTQAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 11:00:24 -0500
Subject: Re: [PATCH] MAINTAINERS: Quote non-alphanumeric email addresses
From: Joe Perches <joe@perches.com>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>
Cc: davem@davemloft.net, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, greg@kroah.com, rdunlap@xenotime.net,
        pavel@ucw.cz
In-Reply-To: <20110220135918.GB1972@gmail.com>
References: <20110210025133.GA3285@gmail.com>
	 <20110209190631.f29419ef.akpm@linux-foundation.org>
	 <20110209.191752.226762899.davem@davemloft.net>
	 <20110219164839.GA20047@ucw.cz> <1298152790.7179.27.camel@Joe-Laptop>
	 <AANLkTi=DbJUFfKA9EMnaUm89Fk2OEDWo64-Lu5H8Yjjv@mail.gmail.com>
	 <20110220024842.GA2138@gmail.com> <1298177214.7179.55.camel@Joe-Laptop>
	 <20110220135918.GB1972@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Feb 2011 08:00:22 -0800
Message-ID: <1298217622.7179.93.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-20 at 21:59 +0800, Harry Wei wrote:
> On Sat, Feb 19, 2011 at 08:46:54PM -0800, Joe Perches wrote:
> > Add quotes around email address with periods and commas.
> Hmm, what about some other conditions except 
> for periods and commas in maintainers' M:. 
> Like following:
> 1> Character '-' in M:

Dashes are not an issue.

> 2> No name of the M:
> M:      support@lsi.com  

Names and angle brackets are optional.

> 3> Messy code in M:
> M:      Benoît Cousson <b-cousson@ti.com>

8 bit characters _might_ be an issue, but
no one has reported any problems yet.

I think you should read and understand rfc 2822
before continuing with this.

Utilities like git send-email and get_maintainer.pl
generally provide email address parsing for only a
subset of all valid address styles.

As these utilities are done mostly by regex, not
all valid email addresses are supported because the
regex validations get ridiculously complicated.

There are some "monster" regex classes that attempt
to support a greater range of valid email address
styles, but the pain of implementation generally
isn't worth it.

You're free to try to improve it of course, but I
think that modifications to the address styles
currently used in MAINTAINERS to remove "special"
address style handling isn't necessary.

