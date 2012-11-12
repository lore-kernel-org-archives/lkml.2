Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab2KLXaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:30:11 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33673 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752285Ab2KLXaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:30:10 -0500
Message-ID: <1352763011.18715.25.camel@joe-AO722>
Subject: Re: [PATCH V2 00/23] printk: refactoring
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Date: Mon, 12 Nov 2012 15:30:11 -0800
In-Reply-To: <20121112152621.eb14d7f0.akpm@linux-foundation.org>
References: <cover.1351135988.git.joe@perches.com>
	 <1351864140.3537.1.camel@joe-AO722> <1352760850.18715.8.camel@joe-AO722>
	 <20121112152621.eb14d7f0.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-12 at 15:26 -0800, Andrew Morton wrote:
> On Mon, 12 Nov 2012 14:54:10 -0800
> Joe Perches <joe@perches.com> wrote:
> 
> > On Fri, 2012-11-02 at 06:49 -0700, Joe Perches wrote:
> > > On Wed, 2012-10-24 at 20:43 -0700, Joe Perches wrote:
> > > > Make printk a bit more readable.
> > > 
> > > Andrew?  Are you going to apply this again for -next?
> > 
> > Andrew?  Any answer?
> 
> Backlogged, not lost.  Hopefully this week or next week.

Thanks.

> I trust it has had more thorough compilation coverage testing
> than v1?

Just a bit.  It does incorporate fixes to all known defects though.

