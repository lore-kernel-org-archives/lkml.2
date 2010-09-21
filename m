Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab0IUFUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 01:20:44 -0400
Received: from mail.perches.com ([173.55.12.10]:2180 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704Ab0IUFUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 01:20:37 -0400
Subject: Re: [PATCH] scripts/get_maintainer.pl: fix .mailmap handling
From: Joe Perches <joe@perches.com>
To: Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, greg@kroah.com,
        stefanr@s5r6.in-berlin.de, broonie@opensource.wolfsonmicro.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>
In-Reply-To: <20100921065921.03f06293@schatten.dmk.lab>
References: <1285021645-14311-1-git-send-email-florian@mickler.org>
	 <1285022156-14501-1-git-send-email-florian@mickler.org>
	 <1285028085.25988.60.camel@Joe-Laptop>
	 <20100921065921.03f06293@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 22:20:35 -0700
Message-ID: <1285046435.25988.131.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 06:59 +0200, Florian Mickler wrote:
> Come on, Joe! It was "sub mailmap" before. @addresses was @list before
> and @ret is the list that get's returned by the function. 

Tell me, what's better as an individual line in perl
with typeless returns
	return @ret;
or
	return @list;

@ret is not descriptive.
Yeah, it's an array.
An array of what?
btw: @list was sub-optimal too.

> If you think a patch is ok, you actually may say so. 

As we discussed privately, yes, .mailmap handling was broken
but both of us seem to think that it's not even necessary as
most .mailmap entries are created manually and it's not
up-to-date.  Name de-duplication is more effective.

.mailmap could be used effectively I suppose, but I asked you
to show a use case where it performs differently than the
existing name de-duplication.

And, I do ack a patch after I think it is ready to be applied.
Until then, I note what I see as shortcomings and defects.

cheers, Joe

