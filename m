Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab0IJKrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:47:04 -0400
Received: from mail.perches.com ([173.55.12.10]:1630 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab0IJKrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:47:03 -0400
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
From: Joe Perches <joe@perches.com>
To: Florian Mickler <florian@mickler.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20100910122213.30caee89@schatten.dmk.lab>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	 <1284111767.1783.35.camel@Joe-Laptop>
	 <20100910095259.GC23903@sirena.org.uk>
	 <1284113066.1783.69.camel@Joe-Laptop>
	 <20100910122213.30caee89@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 03:47:01 -0700
Message-ID: <1284115621.1783.142.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 12:22 +0200, Florian Mickler wrote:
> On Fri, 10 Sep 2010 03:04:26 -0700
> Joe Perches <joe@perches.com> wrote:
> > One possible improvement that get_maintainers could
> > add is to [optionally] CC the author of the first
> > commit when there's no listed maintainer.
> I don't think the first commit has any special significance 
> in general. 

It does depend on the age of the first commit.

The author of the first commit is most frequently
the primary file author and also a current maintainer
or a still significantly interested party.

